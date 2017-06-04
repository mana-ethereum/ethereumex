defmodule EthereumexTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Ethereumex.HttpClient

  setup_all do
    Ethereumex.start([], [])

    :ok
  end

  test "application starts httpclient process" do
    use_cassette "http_client_net_version_request" do
      result = HttpClient.net_version

      {
        :ok,
        %{
          "id" => 2,
          "jsonrpc" => "2.0",
          "result" => "1"
        }
      } = result
    end
  end
end
