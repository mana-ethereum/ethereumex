defmodule Ethereumex.WebsocketClientTest do
  use ExUnit.Case
  use Mimic

  alias Ethereumex.WebsocketClient
  alias Ethereumex.WebsocketServer

  @default_url "ws://localhost:8545"

  setup_all do
    _ = Application.put_env(:ethereumex, :client_type, :websocket)
    _ = Application.put_env(:ethereumex, :websocket_url, @default_url)

    on_exit(fn ->
      _ = Application.put_env(:ethereumex, :client_type, :http)
    end)
  end

  describe "WebsocketClient.web3_client_version/0" do
    test "returns client version" do
      version = "0.0.0"
      expect_ws_post(version)
      assert {:ok, ^version} = WebsocketClient.web3_client_version()
    end
  end

  describe "WebsocketClient.web3_sha3/1" do
    test "returns sha3 of the given data" do
      sha3_data = "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
      expect_ws_post(sha3_data)
      assert {:ok, ^sha3_data} = WebsocketClient.web3_sha3("0x68656c6c6f20776f726c64")
    end
  end

  describe "WebsocketClient.net_version/0" do
    test "returns network id" do
      version = "1"
      expect_ws_post(version)
      assert {:ok, ^version} = WebsocketClient.net_version()
    end
  end

  describe "WebsocketClient.net_peer_count/0" do
    test "returns number of peers currently connected to the client" do
      peer_count = "0x2"
      expect_ws_post(peer_count)
      assert {:ok, ^peer_count} = WebsocketClient.net_peer_count()
    end
  end

  describe "WebsocketClient.net_listening/0" do
    test "returns true" do
      expect_ws_post(true)
      assert {:ok, true} = WebsocketClient.net_listening()
    end
  end

  describe "WebsocketClient.eth_protocol_version/0" do
    test "returns true" do
      protocol_version = "0x3f"
      expect_ws_post(protocol_version)
      assert {:ok, ^protocol_version} = WebsocketClient.eth_protocol_version()
    end
  end

  describe "WebsocketClient.eth_syncing/1" do
    test "checks sync status" do
      expect_ws_post(false)
      assert {:ok, false} = WebsocketClient.eth_syncing()
    end
  end

  describe "WebsocketClient.eth_chain_id/1" do
    test "returns chain id of the RPC serveer" do
      chain_id = "0x1"
      expect_ws_post(chain_id)
      assert {:ok, ^chain_id} = WebsocketClient.eth_chain_id()
    end
  end

  describe "WebsocketClient.eth_coinbase/1" do
    test "returns coinbase address" do
      address = "0x407d73d8a49eeb85d32cf465507dd71d507100c1"
      expect_ws_post(address)
      assert {:ok, ^address} = WebsocketClient.eth_coinbase()
    end
  end

  describe "WebsocketClient.eth_mining/1" do
    test "checks mining status" do
      expect_ws_post(false)
      assert {:ok, false} = WebsocketClient.eth_mining()
    end
  end

  describe "WebsocketClient.eth_hashrate/1" do
    test "returns hashrate" do
      hashrate = "0x0"
      expect_ws_post(hashrate)
      assert {:ok, ^hashrate} = WebsocketClient.eth_hashrate()
    end
  end

  describe "WebsocketClient.eth_gas_price/1" do
    test "returns current price per gas" do
      gas_price = "0x09184e72a000"
      expect_ws_post(gas_price)
      assert {:ok, ^gas_price} = WebsocketClient.eth_gas_price()
    end
  end

  describe "WebsocketClient.eth_max_priority_fee_per_gas/1" do
    test "returns current max priority fee per gas" do
      priority_fee = "0x09184e72a000"
      expect_ws_post(priority_fee)
      assert {:ok, ^priority_fee} = WebsocketClient.eth_max_priority_fee_per_gas()
    end
  end

  describe "WebsocketClient.eth_fee_history/3" do
    test "returns a collection of historical gas information" do
      fee_history = %{
        "baseFeePerGas" => ["0x1", "0x2"],
        "gasUsedRatio" => [0.5, 0.6],
        "oldestBlock" => "0x1",
        "reward" => [["0x1", "0x2"], ["0x3", "0x4"]]
      }

      expect_ws_post(fee_history)
      assert {:ok, ^fee_history} = WebsocketClient.eth_fee_history(1, "latest", [25, 75])
    end
  end

  describe "WebsocketClient.eth_blob_base_fee/1" do
    test "returns the base fee for blob transactions" do
      base_fee = "0x1234"
      expect_ws_post(base_fee)
      assert {:ok, ^base_fee} = WebsocketClient.eth_blob_base_fee()
    end
  end

  describe "WebsocketClient.eth_accounts/1" do
    test "returns addresses owned by client" do
      accounts = ["0x407d73d8a49eeb85d32cf465507dd71d507100c1"]
      expect_ws_post(accounts)
      assert {:ok, ^accounts} = WebsocketClient.eth_accounts()
    end
  end

  describe "WebsocketClient.eth_block_number/1" do
    test "returns number of most recent block" do
      block_number = "0x4b7"
      expect_ws_post(block_number)
      assert {:ok, ^block_number} = WebsocketClient.eth_block_number()
    end
  end

  describe "WebsocketClient.eth_get_balance/3" do
    test "returns balance of given account" do
      balance = "0x0234c8a3397aab58"
      expect_ws_post(balance)

      assert {:ok, ^balance} =
               WebsocketClient.eth_get_balance("0x001bdcde60cb916377a3a3bf4e8054051a4d02e7")
    end
  end

  describe "WebsocketClient.eth_get_storage_at/4" do
    test "returns value from a storage position at a given address." do
      storage_value = "0x0000000000000000000000000000000000000000000000000000000000000000"
      expect_ws_post(storage_value)

      assert {:ok, ^storage_value} =
               WebsocketClient.eth_get_balance(
                 "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7",
                 "0x0"
               )
    end
  end

  describe "WebsocketClient.eth_get_transaction_count/3" do
    test "returns number of transactions sent from an address." do
      count = "0x1"
      expect_ws_post(count)

      assert {:ok, ^count} =
               WebsocketClient.eth_get_transaction_count(
                 "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7"
               )
    end
  end

  describe "WebsocketClient.eth_get_block_transaction_count_by_hash/2" do
    test "number of transactions in a block from a block matching the given block hash" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_block_transaction_count_by_hash(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
               )
    end
  end

  describe "WebsocketClient.eth_get_block_transaction_count_by_number/2" do
    test "returns number of transactions in a block from a block matching the given block number" do
      count = "0x1"
      expect_ws_post(count)
      assert {:ok, ^count} = WebsocketClient.eth_get_block_transaction_count_by_number()
    end
  end

  describe "WebsocketClient.eth_get_uncle_count_by_block_hash/2" do
    test "the number of uncles in a block from a block matching the given block hash" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_uncle_count_by_block_hash(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
               )
    end
  end

  describe "WebsocketClient.eth_get_uncle_count_by_block_number/2" do
    test "the number of uncles in a block from a block matching the given block hash" do
      count = "0x1"
      expect_ws_post(count)
      assert {:ok, ^count} = WebsocketClient.eth_get_uncle_count_by_block_number()
    end
  end

  describe "WebsocketClient.eth_get_code/3" do
    test "returns code at a given address" do
      code =
        "0x600160008035811a818181146012578301005b601b6001356025565b8060005260206000f25b600060078202905091905056"

      expect_ws_post(code)

      assert {:ok, ^code} =
               WebsocketClient.eth_get_code("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b")
    end
  end

  describe "WebsocketClient.eth_sign/3" do
    test "returns signature" do
      signature =
        "0x2ac19db245478a06032e69cdbd2b54e648b78431d0a47bd1fbab18f79f820ba407466e37adbe9e84541cab97ab7d290f4a64a5825c876d22109f3bf813254e8601"

      expect_ws_post(signature)

      assert {:ok, ^signature} =
               WebsocketClient.eth_sign(
                 "0x71cf0b576a95c347078ec2339303d13024a26910",
                 "0xdeadbeaf"
               )
    end
  end

  describe "WebsocketClient.eth_estimate_gas/3" do
    test "estimates gas" do
      data =
        "0x6060604052341561" <>
          "000f57600080fd5b60b38061001d6000396000f3006060604052" <>
          "63ffffffff7c0100000000000000000000000000000000000000" <>
          "00000000000000000060003504166360fe47b181146045578063" <>
          "6d4ce63c14605a57600080fd5b3415604f57600080fd5b605860" <>
          "0435607c565b005b3415606457600080fd5b606a6081565b6040" <>
          "5190815260200160405180910390f35b600055565b6000549056" <>
          "00a165627a7a7230582033edcee10845eead909dccb4e95bb7e4" <>
          "062e92234bf3cfaf804edbd265e599800029"

      gas_estimate = "0x5208"
      expect_ws_post(gas_estimate)

      from = "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7"
      transaction = %{data: data, from: from}

      assert {:ok, ^gas_estimate} = WebsocketClient.eth_estimate_gas(transaction)
    end
  end

  describe "WebsocketClient.eth_get_block_by_hash/3" do
    test "returns information about a block by hash" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_block_by_hash(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238",
                 true
               )
    end
  end

  describe "WebsocketClient.eth_get_block_by_number/3" do
    test "returns information about a block by number" do
      block_info = nil
      expect_ws_post(block_info)
      assert {:ok, ^block_info} = WebsocketClient.eth_get_block_by_number("0x1b4", true)
    end
  end

  describe "WebsocketClient.eth_get_transaction_by_hash/2" do
    test "returns the information about a transaction by its hash" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_transaction_by_hash(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
               )
    end
  end

  describe "WebsocketClient.eth_get_transaction_by_block_hash_and_index/3" do
    test "returns the information about a transaction by block hash and index" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_transaction_by_block_hash_and_index(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238",
                 "0x0"
               )
    end
  end

  describe "WebsocketClient.eth_get_transaction_by_block_number_and_index/3" do
    test "returns the information about a transaction by block number and index" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_transaction_by_block_number_and_index("earliest", "0x0")
    end
  end

  describe "WebsocketClient.eth_get_transaction_receipt/2" do
    test "returns the receipt of a transaction by transaction hash" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_transaction_receipt(
                 "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
               )
    end
  end

  describe "WebsocketClient.eth_get_uncle_by_block_hash_and_index/3" do
    test "returns information about a uncle of a block by hash and uncle index position" do
      expect_ws_post(nil)

      assert {:ok, nil} =
               WebsocketClient.eth_get_uncle_by_block_hash_and_index(
                 "0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b",
                 "0x0"
               )
    end
  end

  describe "WebsocketClient.eth_get_uncle_by_block_number_and_index/3" do
    test "returns information about a uncle of a block by number and uncle index position" do
      uncle_info = %{}
      expect_ws_post(uncle_info)

      assert {:ok, ^uncle_info} =
               WebsocketClient.eth_get_uncle_by_block_number_and_index("0x29c", "0x0")
    end
  end

  describe "WebsocketClient.eth_get_compilers/1" do
    test "returns a list of available compilers in the client" do
      compilers = ["solidity", "lll", "serpent"]
      expect_ws_post(compilers)
      assert {:ok, ^compilers} = WebsocketClient.eth_get_compilers()
    end
  end

  describe "WebsocketClient.eth_new_filter/2" do
    test "creates a filter object" do
      filter = %{
        fromBlock: "0x1",
        toBlock: "0x2",
        address: "0x8888f1f195afa192cfee860698584c030f4c9db1",
        topics: [
          "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
          nil,
          [
            "0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b",
            "0x0000000000000000000000000aff3454fce5edbc8cca8697c15331677e6ebccc"
          ]
        ]
      }

      filter_id = "0x1"
      expect_ws_post(filter_id)
      assert {:ok, ^filter_id} = WebsocketClient.eth_new_filter(filter)
    end
  end

  describe "WebsocketClient.eth_new_block_filter/1" do
    test "creates new block filter" do
      filter_id = "0x1"
      expect_ws_post(filter_id)
      assert {:ok, ^filter_id} = WebsocketClient.eth_new_block_filter()
    end
  end

  describe "WebsocketClient.eth_new_pending_transaction_filter/1" do
    test "creates new pending transaction filter" do
      filter_id = "0x1"
      expect_ws_post(filter_id)
      assert {:ok, ^filter_id} = WebsocketClient.eth_new_pending_transaction_filter()
    end
  end

  describe "WebsocketClient.eth_uninstall_filter/2" do
    test "uninstalls a filter with given id" do
      expect_ws_post(true)
      assert {:ok, true} = WebsocketClient.eth_uninstall_filter("0xb")
    end
  end

  describe "WebsocketClient.eth_get_filter_changes/2" do
    test "returns an array of logs which occurred since last poll" do
      expect_ws_post([])
      assert {:ok, []} = WebsocketClient.eth_get_filter_changes("0x16")
    end
  end

  describe "WebsocketClient.eth_get_filter_logs/2" do
    test "returns an array of all logs matching filter with given id" do
      expect_ws_post([])
      assert {:ok, []} = WebsocketClient.eth_get_filter_logs("0x16")
    end
  end

  describe "WebsocketClient.eth_get_logs/2" do
    test "returns an array of all logs matching a given filter object" do
      filter = %{
        topics: ["0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"]
      }

      expect_ws_post([])
      assert {:ok, []} = WebsocketClient.eth_get_logs(filter)
    end
  end

  describe "WebsocketClient.eth_submit_work/4" do
    test "validates solution" do
      expect_ws_post(false)

      assert {:ok, false} =
               WebsocketClient.eth_submit_work(
                 "0x0000000000000001",
                 "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
                 "0xD1FE5700000000000000000000000000D1FE5700000000000000000000000000"
               )
    end
  end

  describe "WebsocketClient.eth_get_work/1" do
    test "returns the hash of the current block, the seedHash, and the boundary condition to be met " do
      work_data = ["0x1234", "0x5678", "0x9abc"]
      expect_ws_post(work_data)
      assert {:ok, ^work_data} = WebsocketClient.eth_get_work()
    end
  end

  describe "WebsocketClient.eth_submit_hashrate/3" do
    test "submits mining hashrate" do
      expect_ws_post(true)

      assert {:ok, true} =
               WebsocketClient.eth_submit_hashrate(
                 "0x0000000000000000000000000000000000000000000000000000000000500000",
                 "0x59daa26581d0acd1fce254fb7e85952f4c09d0915afd33d3886cd914bc7d283c"
               )
    end
  end

  describe "WebsocketClient.db_put_string/4" do
    test "stores a string in the local database" do
      expect_ws_post(true)
      assert {:ok, true} = WebsocketClient.db_put_string("testDB", "myKey", "myString")
    end
  end

  describe "WebsocketClient.db_get_string/3" do
    test "returns string from the local database" do
      expect_ws_post(nil)
      assert {:ok, nil} = WebsocketClient.db_get_string("db", "key")
    end
  end

  describe "WebsocketClient.db_put_hex/4" do
    test "stores binary data in the local database" do
      expect_ws_post(true)
      assert {:ok, true} = WebsocketClient.db_put_hex("db", "key", "data")
    end
  end

  describe "WebsocketClient.db_get_hex/3" do
    test "returns binary data from the local database" do
      expect_ws_post(nil)
      assert {:ok, nil} = WebsocketClient.db_get_hex("db", "key")
    end
  end

  describe "WebsocketClient.shh_post/2" do
    test "sends a whisper message" do
      whisper = %{
        from:
          "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1",
        to:
          "0x3e245533f97284d442460f2998cd41858798ddf04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a0d4d661997d3940272b717b1",
        topics: [
          "0x776869737065722d636861742d636c69656e74",
          "0x4d5a695276454c39425154466b61693532"
        ],
        payload: "0x7b2274797065223a226d6",
        priority: "0x64",
        ttl: "0x64"
      }

      expect_ws_post(true)
      assert {:ok, true} = WebsocketClient.shh_post(whisper)
    end
  end

  describe "WebsocketClient.shh_version/1" do
    test "returns the current whisper protocol version" do
      version = "2"
      expect_ws_post(version)
      assert {:ok, ^version} = WebsocketClient.shh_version()
    end
  end

  describe "WebsocketClient.shh_new_identity/1" do
    test "creates new whisper identity in the client" do
      identity =
        "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"

      expect_ws_post(identity)
      assert {:ok, ^identity} = WebsocketClient.shh_new_identity()
    end
  end

  describe "WebsocketClient.shh_has_entity/2" do
    test "creates new whisper identity in the client" do
      expect_ws_post(false)

      assert {:ok, false} =
               WebsocketClient.shh_has_identity(
                 "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
               )
    end
  end

  describe "WebsocketClient.shh_add_to_group/2" do
    test "adds adress to group" do
      expect_ws_post(false)

      assert {:ok, false} =
               WebsocketClient.shh_add_to_group(
                 "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
               )
    end
  end

  describe "WebsocketClient.shh_new_group/1" do
    test "creates new group" do
      group_id =
        "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"

      expect_ws_post(group_id)
      assert {:ok, ^group_id} = WebsocketClient.shh_new_group()
    end
  end

  describe "WebsocketClient.shh_new_filter/2" do
    test "creates filter to notify, when client receives whisper message matching the filter options" do
      filter_options = %{
        topics: [~c"0x12341234bf4b564f"],
        to:
          "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
      }

      filter_id = "0x7"
      expect_ws_post(filter_id)
      assert {:ok, ^filter_id} = WebsocketClient.shh_new_filter(filter_options)
    end
  end

  describe "WebsocketClient.shh_uninstall_filter/2" do
    test "uninstalls a filter with given id" do
      expect_ws_post(false)
      assert {:ok, false} = WebsocketClient.shh_uninstall_filter("0x7")
    end
  end

  describe "WebsocketClient.shh_get_filter_changes/2" do
    test "polls filter chages" do
      expect_ws_post([])
      assert {:ok, []} = WebsocketClient.shh_get_filter_changes("0x7")
    end
  end

  describe "WebsocketClient.shh_get_messages/2" do
    test "returns all messages matching a filter" do
      expect_ws_post([])
      assert {:ok, []} = WebsocketClient.shh_get_messages("0x7")
    end
  end

  describe "WebsocketClient.subscribe/2" do
    test "subscribes to newHeads events" do
      subscription_id = "0x9cef478923ff08bf67fde6c64013158d"
      expect_ws_subscribe(subscription_id)
      assert {:ok, ^subscription_id} = WebsocketClient.subscribe(:newHeads)
    end

    test "subscribes to logs with filter params" do
      subscription_id = "0x4a8a4c0517381924f9838102c5a4dcb7"
      filter_params = %{address: "0x8320fe7702b96808f7bbc0d4a888ed1468216cfd"}
      expect_ws_subscribe(subscription_id)
      assert {:ok, ^subscription_id} = WebsocketClient.subscribe(:logs, filter_params)
    end

    test "subscribes to newPendingTransactions" do
      subscription_id = "0x1234567890abcdef1234567890abcdef"
      expect_ws_subscribe(subscription_id)
      assert {:ok, ^subscription_id} = WebsocketClient.subscribe(:newPendingTransactions)
    end
  end

  describe "WebsocketClient.unsubscribe/1" do
    test "unsubscribes from a single subscription" do
      subscription_id = "0x9cef478923ff08bf67fde6c64013158d"
      expect_ws_unsubscribe(true)
      assert {:ok, true} = WebsocketClient.unsubscribe(subscription_id)
    end

    test "unsubscribes from multiple subscriptions" do
      subscription_ids = [
        "0x9cef478923ff08bf67fde6c64013158d",
        "0x4a8a4c0517381924f9838102c5a4dcb7"
      ]

      expect_ws_unsubscribe(true)
      assert {:ok, true} = WebsocketClient.unsubscribe(subscription_ids)
    end
  end

  defp expect_ws_post(response) do
    expect(WebsocketServer, :post, fn _ -> {:ok, response} end)
  end

  defp expect_ws_subscribe(response) do
    expect(WebsocketServer, :subscribe, fn _ -> {:ok, response} end)
  end

  defp expect_ws_unsubscribe(response) do
    expect(WebsocketServer, :unsubscribe, fn _ -> {:ok, response} end)
  end
end
