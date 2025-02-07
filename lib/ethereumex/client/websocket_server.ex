defmodule Ethereumex.WebsocketServer do
  @moduledoc """
  WebSocket client for Ethereum JSON-RPC API.
  Handles connection management and request-response cycle.
  """
  use WebSockex

  alias Ethereumex.Config

  @request_timeout 5_000

  defmodule State do
    @moduledoc """
    Server state containing:
    - url: WebSocket endpoint URL
    - requests: Map of pending requests with their corresponding sender PIDs
    """
    defstruct [:url, requests: %{}]

    @type t :: %__MODULE__{
            url: String.t(),
            requests: %{String.t() => pid()}
          }
  end

  # Public API

  @doc """
  Starts the WebSocket connection.

  ## Options
    - :url - WebSocket endpoint URL (defaults to Config.rpc_url())
    - :name - Process name (defaults to __MODULE__)
  """
  @spec start_link(keyword()) :: {:ok, pid()} | {:error, term()}
  def start_link(opts \\ []) do
    url = Keyword.get(opts, :url, Config.rpc_url())
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
  @spec post(String.t()) :: {:ok, term()} | {:error, term()}
  def post(encoded_request) do
    with {:ok, decoded} <- decode_request(encoded_request),
         :ok <- send_request(decoded, encoded_request) do
      await_response(decoded["id"])
    end
  end

  # Callbacks

  @impl WebSockex
  def handle_connect(_conn, %State{} = state) do
    require Logger
    Logger.info("Connected to WebSocket server at #{state.url}")
    {:ok, state}
  end

  @impl WebSockex
  def handle_cast({:request, id, request, from}, %State{} = state) do
    new_state = update_requests(state, id, from)
    {:reply, {:text, request}, new_state}
  end

  @impl WebSockex
  def handle_frame({:text, body}, %State{} = state) do
    case parse_response(body) do
      {:ok, id, result} -> handle_response(state, id, result)
      {:error, _reason} -> {:ok, state}
    end
  end

  # Private Functions

  @spec decode_request(String.t()) :: {:ok, map()} | {:error, term()}
  defp decode_request(encoded_request) do
    case Jason.decode(encoded_request) do
      {:ok, %{"id" => _id} = decoded} -> {:ok, decoded}
      {:ok, _} -> {:error, :invalid_request_format}
      error -> error
    end
  end

  @spec send_request(map(), String.t()) :: :ok | {:error, term()}
  defp send_request(%{"id" => id}, encoded_request) do
    WebSockex.cast(__MODULE__, {:request, id, encoded_request, self()})
  end

  @spec await_response(String.t()) :: {:ok, term()} | {:error, :timeout}
  defp await_response(id) do
    receive do
      {:response, ^id, result} -> {:ok, result}
    after
      @request_timeout -> {:error, :timeout}
    end
  end

  @spec update_requests(State.t(), String.t(), pid()) :: State.t()
  defp update_requests(state, id, from) do
    %State{state | requests: Map.put(state.requests, id, from)}
  end

  @spec parse_response(String.t()) :: {:ok, String.t(), term()} | {:error, term()}
  defp parse_response(body) do
    case Jason.decode(body) do
      {:ok, %{"id" => id, "result" => result}} -> {:ok, id, result}
      {:ok, %{"id" => id}} -> {:ok, id, nil}
      error -> error
    end
  end

  @spec handle_response(State.t(), String.t(), term()) :: {:ok, State.t()}
  defp handle_response(state, id, result) do
    case Map.get(state.requests, id) do
      nil ->
        {:ok, state}

      from ->
        send(from, {:response, id, result})
        {:ok, %State{state | requests: Map.delete(state.requests, id)}}
    end
  end
end
