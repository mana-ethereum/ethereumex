defmodule Ethereumex.HttpClientTest do
  use ExUnit.Case
  alias Ethereumex.HttpClient

  @moduletag :http

  setup_all do
    HttpClient.start_link

    :ok
  end

  describe "HttpClient.web3_client_version/0" do
    test "returns client version" do
      result = HttpClient.web3_client_version

      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => _
        }
      } = result
    end
  end

  describe "HttpClient.web3_sha3/1" do
    test "returns sha3 of the given data" do
      result = HttpClient.web3_sha3("0x68656c6c6f20776f726c64")

      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
        }
      } = result
    end
  end

  describe "HttpClient.net_version/0" do
    test "returns network id" do
      result = HttpClient.net_version

      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => _
        }
      } = result
    end
  end

  describe "HttpClient.net_peer_count/0" do
    test "returns number of peers currently connected to the client" do
      result = HttpClient.net_peer_count
      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => _
        }
      } = result
    end
  end

  describe "HttpClient.net_listening/0" do
    test "returns true" do
      result = HttpClient.net_listening
      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => true
        }
      } = result
    end
  end


  describe "HttpClient.eth_protocol_version/0" do
    test "returns true" do
      result = HttpClient.eth_protocol_version
      {
        :ok,
        %{
          "id" => _,
          "jsonrpc" => "2.0",
          "result" => _
        }
      } = result
    end
  end

  describe "HttpClient.batch_request/1" do
    test "sends batch request" do
      requests = [
        {:web3_client_version, []},
        {:net_version, []},
        {:web3_sha3, ["0x68656c6c6f20776f726c64"]}
      ]
      result = HttpClient.batch_request(requests)

      {
        :ok,
        [
          %{"id" => id1, "jsonrpc" => "2.0", "result" => _},
          %{"id" => id2, "jsonrpc" => "2.0", "result" => _},
          %{"id" => id3, "jsonrpc" => "2.0", "result" => "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"}
        ]
      } = result

      assert (id1 + 1 == id2) && (id2 + 1 == id3)
    end
  end
end
