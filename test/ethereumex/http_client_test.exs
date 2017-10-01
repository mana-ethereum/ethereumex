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
      result = HttpClient.web3_client_version

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
      result = HttpClient.eth_coinbase

      {
        :error,
        %{
          "code" => -32000,
          "message" => "etherbase address must be explicitly specified"
        }
      } = result
    end
  end

  test "sends request with map as params" do
    use_cassette "http_client_request_with_map_params" do
      params = [%{"data" => "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
                  "from" => "0xc2b7b953C339c6ec4Bb88fAB5a4d19A033e6c4b1", "gas" => "0x76c0",
                  "gasPrice" => "0x9184e72a000",
                  "to" => "0xc2b7b953C339c6ec4Bb88fAB5a4d19A033e6c4b1",
                  "value" => "0x9184e72a"}]

      result = HttpClient.eth_send_transaction(params)

      {
        :error,
        %{
          "code" => -32000,
          "message" => "unknown account"
        }
      } = result
    end
  end

  test "sends custom geth request" do
    use_cassette "http_client_custom_request" do
      result = HttpClient.send_request("rpc_modules")

      {:ok,
       %{"id" => 3,
	 "jsonrpc" => "2.0",
	 "result" =>
	   %{
	     "eth" => "1.0",
	     "net" => "1.0",
	     "rpc" => "1.0",
	     "web3" => "1.0"
	   }
       }
      } = result
    end
  end
end
