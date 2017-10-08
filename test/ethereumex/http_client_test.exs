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

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.web3_sha3/1" do
    test "returns sha3 of the given data" do
      result = HttpClient.web3_sha3("0x68656c6c6f20776f726c64")

      {
        :ok,
        "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
      } = result
    end
  end

  describe "HttpClient.net_version/0" do
    test "returns network id" do
      result = HttpClient.net_version

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.net_peer_count/0" do
    test "returns number of peers currently connected to the client" do
      result = HttpClient.net_peer_count

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.net_listening/0" do
    test "returns true" do
      result = HttpClient.net_listening

      {:ok, true} = result
    end
  end


  describe "HttpClient.eth_protocol_version/0" do
    test "returns true" do
      result = HttpClient.eth_protocol_version

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_syncing/1" do
    test "checks sync status" do
      result = HttpClient.eth_syncing

      {:ok, %{}} = result
    end
  end

  describe "HttpClient.eth_coinbase/1" do
    test "returns coinbase address" do
      result = HttpClient.eth_coinbase

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_mining/1" do
    test "checks mining status" do
      result = HttpClient.eth_mining

      {:ok, false} = result
    end
  end

  describe "HttpClient.eth_hashrate/1" do
    test "returns hashrate" do
      result = HttpClient.eth_hashrate

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_gas_price/1" do
    test "returns current price per gas" do
      result = HttpClient.eth_gas_price

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_accounts/1" do
    test "returns addresses owned by client" do
      result = HttpClient.eth_accounts

      {:ok, [_]} = result
    end
  end

  describe "HttpClient.eth_block_number/1" do
    test "returns number of most recent block" do
      result = HttpClient.eth_block_number

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_balance/3" do
    test "returns balance of given account" do
      result = HttpClient.eth_get_balance("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7")

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_storage_at/4" do
    test "returns value from a storage position at a given address." do
      result = HttpClient.eth_get_balance(
        "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7",
        "0x0"
      )

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_transaction_count/3" do
    test "returns number of transactions sent from an address." do
      result = HttpClient.eth_get_transaction_count("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7")

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_block_transaction_count_by_hash/2" do
    test "number of transactions in a block from a block matching the given block hash" do
      result = HttpClient.eth_get_block_transaction_count_by_hash("0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238")

      {:ok, nil} = result
    end
  end

  describe "HttpClient.eth_get_block_transaction_count_by_number/2" do
    test "returns number of transactions in a block from a block matching the given block number" do
      result = HttpClient.eth_get_block_transaction_count_by_number()

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_uncle_count_by_block_hash/2" do
    test "the number of uncles in a block from a block matching the given block hash" do
      result = HttpClient.eth_get_uncle_count_by_block_hash("0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238")

      {:ok, nil} = result
    end
  end

  describe "HttpClient.eth_get_uncle_count_by_block_number/2" do
    test "the number of uncles in a block from a block matching the given block hash" do
      result = HttpClient.eth_get_uncle_count_by_block_number

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_get_code/3" do
    test "returns code at a given address" do
      result = HttpClient.eth_get_code("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b")

      {:ok, <<_::binary>>} = result
    end
  end

  describe "HttpClient.eth_sign/3" do
    test "returns signature" do
      result = HttpClient.eth_sign("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7", "0xdeadbeaf")

      {:ok, <<_::binary>>} = result
    end
  end

  # describe "HttpClient.eth_send_transaction/2" do
  #   test "sends transaction" do
  #     transaction =
  #       %{
  #         "from" => "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7",
  #         "data" => ""
  #       }
  #     result = HttpClient.eth_send_transaction(transaction)

  #     {:ok, <<_::binary>>} = result
  #   end
  # end

  # describe "HttpClient.eth_send_raw_transaction/2" do
  #   test "sends transaction" do
  #     data = "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"
  #     result = HttpClient.eth_send_raw_transaction(data)

  #     {
  #       :ok,
  #       %{
  #         "id" => _,
  #         "jsonrpc" => "2.0",
  #         "result" => _
  #       }
  #     } = result
  #   end
  # end

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
          <<_::binary>>,
          <<_::binary>>,
          "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
        ]
      } = result
    end
  end
end
