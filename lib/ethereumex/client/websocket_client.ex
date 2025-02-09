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

  alias Ethereumex.WebsocketServer

  def post_request(payload, _opts) do
    WebsocketServer.post(payload)
  end
end
