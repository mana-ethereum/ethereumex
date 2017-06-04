defmodule Ethereumex.HttpClientTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Ethereumex.HttpClient

  setup_all do
    HttpClient.start_link

    :ok
  end

  test "sends successfull request" do
    use_cassette "http_client_request" do
      result = HttpClient.web3_client_version([])

      {
        :ok,
        %{
          "id" => 0,
          "jsonrpc" => "2.0",
          "result" => "Geth/v1.6.5-stable-cf87713d/darwin-amd64/go1.8.3"
        }
      } = result
    end
  end

  test "sends failed request" do
    use_cassette "http_client_failed_request" do
      result = HttpClient.eth_coinbase([])

      {
        :error,
        %{
          "code" => -32000,
          "message" => "etherbase address must be explicitly specified"
        }
      } = result
    end
  end
end
