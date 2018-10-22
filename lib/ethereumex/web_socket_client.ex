defmodule Ethereumex.WebSocketClient do
  alias Ethereumex.WebSocketServer
  use Ethereumex.Client.BaseClient

  @moduledoc false

  @spec post_request(binary(), [], integer()) :: {:ok | :error, any()}
  def post_request(payload, _opts, request_id) do
    response = WebSocketServer.send_message(payload, request_id)

    {:ok, response["result"]}
  end

  def eth_subscribe(subscription_type) do
    {:ok, subscription_id} = "eth_subscribe" |> request([subscription_type], [])

    WebSocketServer.subscribe(subscription_id)
  end
end
