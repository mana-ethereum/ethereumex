defmodule Ethereumex.WebsocketClient do
  @moduledoc """
  WebSocket-based Ethereum JSON-RPC client implementation.

  This module provides a WebSocket client interface for Ethereum JSON-RPC calls by:
  1. Inheriting the standard JSON-RPC method definitions from BaseClient
  2. Implementing request handling through a persistent WebSocket connection

  ## Usage

      iex> Ethereumex.WebsocketClient.eth_block_number()
      {:ok, "0x1234"}

      iex> Ethereumex.WebsocketClient.eth_get_balance("0x407d73d8a49eeb85d32cf465507dd71d507100c1")
      {:ok, "0x0234c8a3397aab58"}

  The client maintains a persistent WebSocket connection through `WebsocketServer`,
  which handles connection management, request-response matching, and automatic
  reconnection on failures.

  All JSON-RPC methods defined in `Ethereumex.Client.BaseClient` are available
  through this client, with requests being sent over WebSocket instead of HTTP.
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
  Unsubscribes from an existing subscription.

  ## Parameters
    - subscription_id: The ID returned from subscribe/2

  ## Example

      iex> unsubscribe("0x9cef478923ff08bf67fde6c64013158d")
      {:ok, true}

  Returns `{:ok, true}` on success or `{:error, reason}` on failure.
  """
  @spec unsubscribe(String.t()) :: {:ok, boolean()} | {:error, term()}
  def unsubscribe(subscription_id) do
    method = "eth_unsubscribe"

    request = %{
      jsonrpc: "2.0",
      method: method,
      params: [subscription_id],
      id: Counter.increment(:rpc_counter, method)
    }

    WebsocketServer.unsubscribe(request)
  end
end
