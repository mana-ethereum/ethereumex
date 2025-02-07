defmodule Ethereumex.WebsocketClient do
  @moduledoc false

  use Ethereumex.Client.BaseClient

  alias Ethereumex.WebsocketServer

  def post_request(payload, _opts) do
    WebsocketServer.post(payload)
  end
end
