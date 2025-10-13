defmodule Ethereumex.WebsocketServer do
  @moduledoc """
  WebSocket client implementation for Ethereum JSON-RPC API.

  This module manages a persistent WebSocket connection to an Ethereum node and handles
  the complete request-response cycle for JSON-RPC calls, including subscriptions. It maintains
  state of ongoing requests, subscriptions, and matches responses to their original callers.

  ## Features

  * Standard JSON-RPC requests via WebSocket
  * Real-time event subscriptions (newHeads, logs, newPendingTransactions)
  * Automatic reconnection with exponential backoff
  * Batch request support
  * Concurrent request handling

  ## Request Types

  ### Standard Requests

  Standard JSON-RPC requests are handled through the `post/1` function:

  ```elixir
  {:ok, result} = WebsocketServer.post(encoded_request)
  ```

  ### Subscriptions

  The module supports Ethereum's pub/sub functionality for real-time events:

  ```elixir
  # Subscribe to new block headers
  {:ok, subscription_id} = WebsocketServer.subscribe(%{
    jsonrpc: "2.0",
    method: "eth_subscribe",
    params: ["newHeads"],
    id: 1
  })

  # Subscribe to logs with filter
  {:ok, subscription_id} = WebsocketServer.subscribe(%{
    jsonrpc: "2.0",
    method: "eth_subscribe",
    params: ["logs", %{address: "0x123..."}],
    id: 2
  })

  # Unsubscribe (single or multiple subscriptions)
  {:ok, true} = WebsocketServer.unsubscribe(%{
    jsonrpc: "2.0",
    method: "eth_unsubscribe",
    params: [subscription_id],
    id: 3
  })
  ```

  ## State Management

  The module maintains several state maps:

  ```elixir
  %State{
    requests: %{request_id => caller_pid},                    # Standard requests
    subscription_requests: %{request_id => caller_pid},       # Pending subscriptions
    unsubscription_requests: %{request_id => caller_pid},     # Pending unsubscriptions
    subscriptions: %{subscription_id => subscriber_pid}       # Active subscriptions
  }
  ```

  ## Subscription Notifications

  When a subscribed event occurs, the notification is automatically forwarded to the
  subscriber process. Notifications are received as messages in the format:

  ```elixir
  # New headers notification
  %{
    "jsonrpc" => "2.0",
    "method" => "eth_subscription",
    "params" => %{
      "subscription" => "0x9cef478923ff08bf67fde6c64013158d",
      "result" => %{
        "number" => "0x1b4",
        "hash" => "0x8216c5785ac562ff41e2dcfdf5785ac562ff41e2dcfdf829c5a142f1fccd7d",
        "parentHash" => "0x9646252be9520f6e71339a8df9c55e4d7619deeb018d2a3f2d21fc165dde5eb5"
      }
    }
  }

  # Logs notification
  %{
    "jsonrpc" => "2.0",
    "method" => "eth_subscription",
    "params" => %{
      "subscription" => "0x4a8a4c0517381924f9838102c5a4dcb7",
      "result" => %{
        "address" => "0x8320fe7702b96808f7bbc0d4a888ed1468216cfd",
        "topics" => ["0xd78a0cb8bb633d06981248b816e7bd33c2a35a6089241d099fa519e361cab902"],
        "data" => "0x000000000000000000000000000000000000000000000000000000000000000a"
      }
    }
  }
  ```

  ## Error Handling

  - Connection failures are automatically retried with exponential backoff:
    * Up to `@max_reconnect_attempts` attempts
    * Starting with `@backoff_initial_delay` ms delay, doubling each attempt
    * Reconnection attempts are logged
  - Request timeouts after `@request_timeout` ms
  - Invalid JSON responses are handled gracefully
  - Unmatched responses (no waiting caller) are safely ignored
  - Subscription errors are propagated to the subscriber
  """
  use WebSockex

  alias Ethereumex.Config

  require Logger

  @request_timeout 5_000
  @max_reconnect_attempts 5
  @backoff_initial_delay 1_000

  @type request_id :: pos_integer() | String.t()
  @type subscription_id :: String.t()
  @type event_type :: :newHeads | :logs | :newPendingTransactions

  defmodule State do
    @moduledoc """
    Server state containing:
    - url: WebSocket endpoint URL
    - requests: Map of pending requests with their corresponding sender PIDs
    - subscription requests: Map of pending subscription requests with their corresponding sender PIDs
    - unsubscription requests: Map of pending unsubscription requests with their corresponding sender PIDs
    - subscriptions: Map of subscription IDs to subscriber PIDs
    """
    defstruct [
      :url,
      requests: %{},
      subscription_requests: %{},
      unsubscription_requests: %{},
      subscriptions: %{},
      reconnect_attempts: 0
    ]

    @type t :: %__MODULE__{
            url: String.t(),
            requests: %{Ethereumex.WebsocketServer.request_id() => pid()},
            subscription_requests: %{Ethereumex.WebsocketServer.request_id() => pid()},
            unsubscription_requests: %{Ethereumex.WebsocketServer.request_id() => pid()},
            subscriptions: %{Ethereumex.WebsocketServer.subscription_id() => pid()},
            reconnect_attempts: non_neg_integer()
          }
  end

  # Public API

  @doc """
  Starts the WebSocket connection.

  ## Options
    - :url - WebSocket endpoint URL (defaults to Config.websocket_url())
    - :name - Process name (defaults to __MODULE__)
  """
  @spec start_link(keyword()) :: {:ok, pid()} | {:error, term()}
  def start_link(opts \\ []) do
    url = Keyword.get(opts, :url, Config.websocket_url())
    name = Keyword.get(opts, :name, __MODULE__)

    WebSockex.start_link(
      url,
      __MODULE__,
      %State{url: url},
      name: name,
      handle_initial_conn_failure: true
    )
  end

  @doc """
  Sends a JSON-RPC request and waits for response.

  Returns `{:ok, result}` on success or `{:error, reason}` on failure.
  Times out after #{@request_timeout}ms.
  """
  @spec post(binary()) ::
          {:ok, term()} | {:error, :invalid_request_format | :timeout | :decoded_error}
  def post(encoded_request) when is_binary(encoded_request) do
    with {:ok, decoded} <- decode_request(encoded_request),
         id <- get_request_id(decoded),
         :ok <- send_request(id, encoded_request) do
      await_response(id)
    end
  end

  @doc """
  Subscribes to Ethereum events via WebSocket.

  The request should be a map containing:
  - id: A unique request identifier
  - method: "eth_subscribe"
  - params: Parameters for the subscription, including the event type

  Returns `{:ok, subscription_id}` on success or `{:error, reason}` on failure.
  Times out after #{@request_timeout}ms.
  """
  @spec subscribe(map()) ::
          {:ok, subscription_id()} | {:error, :invalid_request_format | :timeout | :decoded_error}
  def subscribe(request) do
    :ok = WebSockex.cast(__MODULE__, {:subscription, request, self()})
    await_response(request.id)
  end

  @doc """
  Unsubscribes from an existing Ethereum event subscription.

  The request should be a map containing:
  - id: A unique request identifier
  - method: "eth_unsubscribe"
  - params: A list containing the subscription IDs to unsubscribe from

  Returns `{:ok, true}` on success or `{:error, reason}` on failure.
  Times out after #{@request_timeout}ms.
  """
  @spec unsubscribe(map()) ::
          {:ok, true} | {:error, :invalid_request_format | :timeout | :decoded_error}
  def unsubscribe(request) do
    :ok = WebSockex.cast(__MODULE__, {:unsubscribe, request, self()})
    await_response(request.id)
  end

  # Callbacks

  @impl WebSockex
  def handle_connect(_conn, %State{} = state) do
    Logger.info("Connected to WebSocket server at #{state.url}")
    {:ok, %{state | reconnect_attempts: 0}}
  end

  @impl WebSockex
  def handle_cast({:request, id, request, from}, %State{} = state) do
    requests = Map.put(state.requests, id, from)
    new_state = %{state | requests: requests}
    {:reply, {:text, request}, new_state}
  end

  def handle_cast({:subscription, request, from}, %State{} = state) do
    subscription_requests = Map.put(state.subscription_requests, request.id, from)
    new_state = %{state | subscription_requests: subscription_requests}
    {:reply, {:text, Config.json_module().encode!(request)}, new_state}
  end

  def handle_cast({:unsubscribe, request, from}, %State{} = state) do
    unsubscription_requests =
      Map.put(state.unsubscription_requests, request.id, {from, request.params})

    new_state = %{state | unsubscription_requests: unsubscription_requests}
    {:reply, {:text, Config.json_module().encode!(request)}, new_state}
  end

  @impl WebSockex
  def handle_frame({:text, body}, %State{} = state) do
    case Config.json_module().decode(body) do
      {:ok, response} -> handle_response(response, state)
      _ -> {:ok, state}
    end
  end

  @impl WebSockex
  def handle_disconnect(%{reason: {:local, _reason}}, state) do
    {:ok, state}
  end

  @impl WebSockex
  def handle_disconnect(connection_status, %State{} = state) do
    new_attempts = state.reconnect_attempts + 1

    if should_retry?(new_attempts) do
      handle_retry(connection_status, state, new_attempts)
    else
      handle_max_attempts_reached(connection_status, state)
    end
  end

  # Private Functions

  @spec decode_request(String.t()) :: {:ok, map()} | {:error, term()}
  defp decode_request(encoded_request) do
    case Config.json_module().decode(encoded_request) do
      {:ok, %{"id" => _id} = decoded} -> {:ok, decoded}
      {:ok, decoded} when is_list(decoded) -> {:ok, decoded}
      {:ok, _} -> {:error, :invalid_request_format}
      _error -> {:error, :decode_error}
    end
  end

  @spec send_request(request_id(), String.t()) :: :ok
  defp send_request(id, encoded_request) do
    WebSockex.cast(__MODULE__, {:request, id, encoded_request, self()})
  end

  @spec await_response(request_id()) :: {:ok, term()} | {:error, :timeout}
  defp await_response(id) do
    receive do
      {:response, ^id, result} -> {:ok, result}
    after
      @request_timeout -> {:error, :timeout}
    end
  end

  # when a response is a subscription notification
  defp handle_response(%{"method" => "eth_subscription"} = notification, state) do
    subscription = notification["params"]["subscription"]
    subscriber = Map.get(state.subscriptions, subscription)

    if not is_nil(subscriber) do
      send(subscriber, notification)
    end

    {:ok, state}
  end

  # when a response is a regular JSON-RPC response
  defp handle_response(response, state) do
    id = get_request_id(response)
    result = get_response_result(response)

    state =
      cond do
        Map.has_key?(state.requests, id) ->
          handle_request_response(state, id, result)

        Map.has_key?(state.subscription_requests, id) ->
          handle_subscription_response(state, id, result)

        Map.has_key?(state.unsubscription_requests, id) ->
          handle_unsubscription_response(state, id, result)

        true ->
          state
      end

    {:ok, state}
  end

  defp handle_request_response(%State{} = state, id, result) do
    send(Map.get(state.requests, id), {:response, id, result})
    %{state | requests: Map.delete(state.requests, id)}
  end

  defp handle_subscription_response(%State{} = state, id, result) do
    pid = Map.get(state.subscription_requests, id)
    send(pid, {:response, id, result})

    subscription_requests = Map.delete(state.subscription_requests, id)
    subscriptions = Map.put(state.subscriptions, result, pid)
    %{state | subscription_requests: subscription_requests, subscriptions: subscriptions}
  end

  defp handle_unsubscription_response(%State{} = state, id, result) do
    {pid, subscription_ids} = Map.get(state.unsubscription_requests, id)
    send(pid, {:response, id, result})

    subscription_requests = Map.delete(state.subscription_requests, id)
    subscriptions = Map.drop(state.subscriptions, subscription_ids)
    %{state | subscription_requests: subscription_requests, subscriptions: subscriptions}
  end

  @spec get_request_id(list(map()) | map()) :: request_id()
  defp get_request_id(%{"id" => id}), do: id

  defp get_request_id(decoded_request) when is_list(decoded_request) do
    Enum.map_join(decoded_request, "_", & &1["id"])
  end

  @spec get_response_result(list(map()) | map()) :: term() | nil
  defp get_response_result(%{"result" => result}), do: result

  defp get_response_result(result) when is_list(result) do
    Enum.map(result, & &1["result"])
  end

  defp get_response_result(_), do: nil

  defp should_retry?(attempts), do: attempts <= @max_reconnect_attempts

  defp handle_retry(connection_status, %State{} = state, attempts) do
    log_retry_attempt(connection_status.reason, attempts)
    apply_backoff_delay(attempts)
    {:reconnect, %{state | reconnect_attempts: attempts}}
  end

  defp handle_max_attempts_reached(connection_status, state) do
    Logger.error(
      "WebSocket disconnected: #{inspect(connection_status.reason)}. " <>
        "Max reconnection attempts (#{@max_reconnect_attempts}) reached."
    )

    {:ok, state}
  end

  defp log_retry_attempt(reason, attempts) do
    Logger.warning(
      "WebSocket disconnected: #{inspect(reason)}. " <>
        "Attempting reconnection #{attempts}/#{@max_reconnect_attempts}"
    )
  end

  defp apply_backoff_delay(attempts) do
    backoff = @backoff_initial_delay * :math.pow(2, attempts - 1)
    Process.sleep(trunc(backoff))
  end
end
