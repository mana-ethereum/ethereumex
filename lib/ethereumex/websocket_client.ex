defmodule Ethereumex.WebsocketClient do
  @moduledoc """
  WebSocket-based Ethereum JSON-RPC client implementation with real-time subscription support.

  This module provides a WebSocket client interface for both standard Ethereum JSON-RPC calls
  and real-time event subscriptions. It:
  1. Inherits the standard JSON-RPC method definitions from BaseClient
  2. Implements request handling through a persistent WebSocket connection
  3. Provides subscription management for real-time events

  ## Standard RPC Usage

      iex> Ethereumex.WebsocketClient.eth_block_number()
      {:ok, "0x1234"}

      iex> Ethereumex.WebsocketClient.eth_get_balance("0x407d73d8a49eeb85d32cf465507dd71d507100c1")
      {:ok, "0x0234c8a3397aab58"}

  ## Subscription Usage

  ### Subscribe to New Blocks
      iex> {:ok, subscription_id} = Ethereumex.WebsocketClient.subscribe(:newHeads)
      {:ok, "0x9cef478923ff08bf67fde6c64013158d"}

      # Receive notifications in the subscriber process
      receive do
        %{
          "method" => "eth_subscription",
          "params" => %{
            "subscription" => "0x9cef478923ff08bf67fde6c64013158d",
            "result" => %{"number" => "0x1b4", ...}
          }
        } -> :ok
      end

  ### Subscribe to Contract Events
      iex> filter = %{
      ...>   address: "0x8320fe7702b96808f7bbc0d4a888ed1468216cfd",
      ...>   topics: ["0xd78a0cb8bb633d06981248b816e7bd33c2a35a6089241d099fa519e361cab902"]
      ...> }
      iex> {:ok, subscription_id} = Ethereumex.WebsocketClient.subscribe(:logs, filter)
      {:ok, "0x4a8a4c0517381924f9838102c5a4dcb7"}

  ### Subscribe to Pending Transactions
      iex> {:ok, subscription_id} = Ethereumex.WebsocketClient.subscribe(:newPendingTransactions)
      {:ok, "0x1234567890abcdef1234567890abcdef"}

  ### Unsubscribe
      # Single subscription
      iex> Ethereumex.WebsocketClient.unsubscribe("0x9cef478923ff08bf67fde6c64013158d")
      {:ok, true}

      # Multiple subscriptions
      iex> Ethereumex.WebsocketClient.unsubscribe([
      ...>   "0x9cef478923ff08bf67fde6c64013158d",
      ...>   "0x4a8a4c0517381924f9838102c5a4dcb7"
      ...> ])
      {:ok, true}

  ## Features

  * All standard JSON-RPC methods from `Ethereumex.Client.BaseClient`
  * Real-time event subscriptions:
    - New block headers (`:newHeads`)
    - Log events (`:logs`)
    - Pending transactions (`:newPendingTransactions`)
  * Automatic WebSocket connection management
  * Request-response matching
  * Automatic reconnection on failures

  The client maintains a persistent WebSocket connection through `WebsocketServer`,
  which handles connection management, request-response matching, subscription
  management, and automatic reconnection on failures.
  """

  use Ethereumex.Client.BaseClient

  alias Ethereumex.Counter
  alias Ethereumex.WebsocketServer

  @event_types [:newHeads, :logs, :newPendingTransactions]

  def post_request(payload, _opts) do
    WebsocketServer.post(payload)
  end

  @doc """
  Subscribes to Ethereum events.

  ## Parameters
    - event_type: Type of event to subscribe to (:newHeads, :logs, :newPendingTransactions)
    - filter_params: Optional parameters for filtering events (mainly used for :logs)

  ## Examples

      # Subscribe to new blocks
      iex> subscribe(:newHeads)
      {:ok, "0x9cef478923ff08bf67fde6c64013158d"}

      # Subscribe to specific logs
      iex> subscribe(:logs, %{address: "0x8320fe7702b96808f7bbc0d4a888ed1468216cfd"})
      {:ok, "0x4a8a4c0517381924f9838102c5a4dcb7"}

  Returns `{:ok, subscription_id}` on success or `{:error, reason}` on failure.
  """
  @spec subscribe(WebsocketServer.event_type(), map() | nil) ::
          {:ok, String.t()} | {:error, term()}
  def subscribe(event_type, filter_params \\ nil) when event_type in @event_types do
    params = [Atom.to_string(event_type)]
    params = if filter_params, do: params ++ [filter_params], else: params

    method = "eth_subscribe"

    request = %{
      jsonrpc: "2.0",
      method: method,
      params: params,
      id: Counter.increment(:rpc_counter, method)
    }

    WebsocketServer.subscribe(request)
  end

  @doc """
  Unsubscribes from one or more existing subscriptions.

  ## Parameters
    - subscription_ids: A single subscription ID or a list of subscription IDs returned from subscribe/2

  ## Examples

      # Unsubscribe from a single subscription
      iex> unsubscribe("0x9cef478923ff08bf67fde6c64013158d")
      {:ok, true}

      # Unsubscribe from multiple subscriptions at once
      iex> unsubscribe(["0x9cef478923ff08bf67fde6c64013158d", "0x4a8a4c0517381924f9838102c5a4dcb7"])
      {:ok, true}

  Returns `{:ok, true}` on success or `{:error, reason}` on failure.
  """
  @spec unsubscribe(String.t() | list(String.t())) :: {:ok, boolean()} | {:error, term()}
  def unsubscribe(subscription_ids) when is_list(subscription_ids) do
    method = "eth_unsubscribe"

    request = %{
      jsonrpc: "2.0",
      method: method,
      params: subscription_ids,
      id: Counter.increment(:rpc_counter, method)
    }

    WebsocketServer.unsubscribe(request)
  end

  def unsubscribe(subscription_id) when is_binary(subscription_id) do
    unsubscribe([subscription_id])
  end
end
