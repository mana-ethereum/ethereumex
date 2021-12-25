defmodule Ethereumex.Client.BaseClientTest do
  use ExUnit.Case

  defmodule ClientMock do
    use Ethereumex.Client.BaseClient

    def post_request(payload, opts) do
      case Jason.decode!(payload) do
        %{"method" => method, "jsonrpc" => "2.0", "params" => params} ->
          {method, params, opts}

        batch_requests when is_list(batch_requests) ->
          batch_requests
      end
    end
  end

  defmodule Helpers do
    def check(method, params \\ [], defaults \\ []) do
      method
      |> make_tuple
      |> assert_method(params, params ++ defaults)
    end

    def assert_method({ex_method, eth_method}, params, payload) do
      {result_eth_method, result_payload, _opts} =
        apply(ClientMock, String.to_atom(ex_method), params)

      assert result_eth_method == eth_method
      assert result_payload == payload
    end

    def assert_opts({ex_method, _eth_method}, params, opts) do
      {_eth_method, _payload, result_opts} = apply(ClientMock, String.to_atom(ex_method), params)

      assert result_opts == opts
    end

    def make_tuple(ex_method) do
      eth_method =
        ex_method
        |> String.split("_")
        |> uppercase

      {ex_method, eth_method}
    end

    def uppercase([first]), do: first
    def uppercase([first, second]), do: Enum.join([first, second], "_")
    # web3_client_version -> web3_clientVersion and keep this logic
    def uppercase([first, second | tail]) do
      uppered = Enum.map_join(tail, &String.capitalize/1)

      Enum.join([first, second], "_") <> uppered
    end
  end

  @address "0x407d73d8a49eeb85d32cf465507dd71d507100c1"
  @hash "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
  @hex_232 "0xe8"
  @transaction %{
    "from" => @address,
    "to" => @address,
    "gas" => @hex_232,
    "gasPrice" => @hex_232,
    "value" => @hex_232,
    "data" => @hash
  }
  @source_code "(returnlll (suicide (caller)))"
  @filter %{
    "fromBlock" => "0x1",
    "toBlock" => "0x2",
    "address" => "0x8888f1f195afa192cfee860698584c030f4c9db1",
    "topics" => ["0x000000000000000000000000a94f5374fce5edbc8e2a8697c15331677e6ebf0b"]
  }

  describe ".web3_client_version/0" do
    test "with configuration url", do: Helpers.check("web3_client_version")

    test "with dynamic url",
      do:
        Helpers.assert_opts(
          {"web3_client_version", "web3_client_version"},
          [[url: "http://localhost:4000"]],
          url: "http://localhost:4000"
        )
  end

  test ".net_version/0", do: Helpers.check("net_version")
  test ".net_peer_count/0", do: Helpers.check("net_peer_count")
  test ".net_listening/0", do: Helpers.check("net_listening")
  test ".eth_protocol_version/0", do: Helpers.check("eth_protocol_version")
  test ".eth_syncing/0", do: Helpers.check("eth_syncing")
  test ".eth_coinbase/0", do: Helpers.check("eth_coinbase")
  test ".eth_mining/0", do: Helpers.check("eth_mining")
  test ".eth_hashrate/0", do: Helpers.check("eth_hashrate")
  test ".eth_gas_price/0", do: Helpers.check("eth_gas_price")
  test ".eth_accounts/0", do: Helpers.check("eth_accounts")
  test ".eth_block_number/0", do: Helpers.check("eth_block_number")
  test ".eth_get_compilers/0", do: Helpers.check("eth_get_compilers")
  test ".eth_new_block_filter/0", do: Helpers.check("eth_new_block_filter")

  test ".eth_new_pending_transaction_filter/0",
    do: Helpers.check("eth_new_pending_transaction_filter")

  describe ".eth_get_proof/3" do
    test "w/o params",
      do: Helpers.check("eth_get_proof", [@address, [@hex_232, @hex_232]], ["latest"])

    test "with number",
      do: Helpers.check("eth_get_proof", [@address, [@hex_232, @hex_232], [@hex_232]])
  end

  test ".eth_get_work/0", do: Helpers.check("eth_get_work")
  test ".shh_version/0", do: Helpers.check("shh_version")
  test ".shh_new_identity/0", do: Helpers.check("shh_new_identity")
  test ".shh_new_group/0", do: Helpers.check("shh_new_group")

  describe "eth_get_block_transaction_count_by_number/0" do
    test "w/o params",
      do: Helpers.check("eth_get_block_transaction_count_by_number", [], ["latest"])

    test "with number", do: Helpers.check("eth_get_block_transaction_count_by_number", [@hex_232])
  end

  describe "eth_get_uncle_count_by_block_number/0" do
    test "w/o params",
      do: Helpers.check("eth_get_uncle_count_by_block_number", [], ["latest"])

    test "with number", do: Helpers.check("eth_get_uncle_count_by_block_number", [@hex_232])
  end

  test ".web3_sha3/1", do: Helpers.check("web3_sha3", ["string to be hashed"])

  test ".eth_get_balance/1",
    do: Helpers.check("eth_get_balance", [@address], ["latest"])

  test ".eth_get_storage_at/1",
    do: Helpers.check("eth_get_storage_at", [@address, "0x0"], ["latest"])

  test ".eth_get_transaction_count/1",
    do: Helpers.check("eth_get_transaction_count", [@address], ["latest"])

  test ".eth_get_block_transaction_count_by_hash/1",
    do: Helpers.check("eth_get_block_transaction_count_by_hash", [@hash])

  test ".eth_get_uncle_count_by_block_hash/1",
    do: Helpers.check("eth_get_uncle_count_by_block_hash", [@hash])

  test ".eth_get_code/1",
    do: Helpers.check("eth_get_code", [@address], ["latest"])

  test ".eth_sign/2",
    do: Helpers.check("eth_sign", [@address, "data to sign"])

  test ".eth_send_transaction/1",
    do: Helpers.check("eth_send_transaction", [@transaction])

  test ".eth_send_raw_transaction/1",
    do: Helpers.check("eth_send_raw_transaction", [@hash])

  test ".eth_call/1",
    do: Helpers.check("eth_call", [@transaction], ["latest"])

  test ".eth_estimate_gas/1",
    do: Helpers.check("eth_estimate_gas", [@transaction])

  test ".eth_get_block_by_hash/2",
    do: Helpers.check("eth_get_block_by_hash", [@hash, false])

  test ".eth_get_block_by_number/2",
    do: Helpers.check("eth_get_block_by_number", [@hex_232, false])

  test ".eth_get_transaction_by_hash/1",
    do: Helpers.check("eth_get_transaction_by_hash", [@hash])

  test ".eth_get_transaction_by_block_hash_and_index/2",
    do: Helpers.check("eth_get_transaction_by_block_hash_and_index", [@hash, "0x0"])

  test ".eth_get_transaction_by_block_number_and_index/2",
    do: Helpers.check("eth_get_transaction_by_block_number_and_index", ["0x29c", "0x0"])

  test ".eth_get_transaction_receipt/1",
    do: Helpers.check("eth_get_transaction_receipt", [@hash])

  test ".eth_get_uncle_by_block_hash_and_index/2",
    do: Helpers.check("eth_get_uncle_by_block_hash_and_index", [@hash, "0x0"])

  test ".eth_get_uncle_by_block_number_and_index/2",
    do: Helpers.check("eth_get_uncle_by_block_number_and_index", ["0x29c", "0x0"])

  test "eth_compile_lll/1" do
    Helpers.assert_method({"eth_compile_lll", "eth_compileLLL"}, [@source_code], [@source_code])
  end

  test ".eth_compile_solidity/1",
    do: Helpers.check("eth_compile_solidity", [@source_code])

  test ".eth_compile_serpent/1",
    do: Helpers.check("eth_compile_serpent", [@source_code])

  test ".eth_new_filter/1",
    do: Helpers.check("eth_new_filter", [@filter])

  test ".eth_uninstall_filter/1",
    do: Helpers.check("eth_uninstall_filter", ["0xb"])

  test ".eth_get_filter_changes/1",
    do: Helpers.check("eth_get_filter_changes", ["0xb"])

  test ".eth_get_filter_logs/1",
    do: Helpers.check("eth_get_filter_logs", ["0xb"])

  test ".eth_get_logs/1",
    do: Helpers.check("eth_get_logs", [@filter])

  test ".eth_submit_work/3" do
    params = [
      "0x0000000000000001",
      "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
      "0xD1FE5700000000000000000000000000D1FE5700000000000000000000000000"
    ]

    Helpers.check("eth_submit_work", params)
  end

  test ".eth_submit_hashrate/2" do
    params = [
      "0x0000000000000000000000000000000000000000000000000000000000500000",
      "0x59daa26581d0acd1fce254fb7e85952f4c09d0915afd33d3886cd914bc7d283c"
    ]

    Helpers.check("eth_submit_hashrate", params)
  end

  test ".db_put_string/3" do
    params = [
      "testDB",
      "myKey",
      "myString"
    ]

    Helpers.check("db_put_string", params)
  end

  test ".db_get_string/2" do
    params = [
      "testDB",
      "myKey"
    ]

    Helpers.check("db_get_string", params)
  end

  test ".db_put_hex/3" do
    params = [
      "testDB",
      "myKey",
      "0x68656c6c6f20776f726c64"
    ]

    Helpers.check("db_put_hex", params)
  end

  test ".db_get_hex/2" do
    params = [
      "testDB",
      "myKey"
    ]

    Helpers.check("db_get_hex", params)
  end

  test ".shh_post/1" do
    params = %{
      "from" =>
        "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1",
      "to" =>
        "0x3e245533f97284d442460f2998cd41858798ddf04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a0d4d661997d3940272b717b1",
      "topics" => [
        "0x776869737065722d636861742d636c69656e74",
        "0x4d5a695276454c39425154466b61693532"
      ],
      "payload" => "0x7b2274797065223a226d6",
      "priority" => "0x64",
      "ttl" => "0x64"
    }

    Helpers.check("shh_post", [params])
  end

  test ".shh_has_identity/1",
    do: Helpers.check("shh_has_identity", [@address])

  test ".shh_add_to_group/1",
    do: Helpers.check("shh_add_to_group", [@address])

  test ".shh_new_filter/2" do
    params = %{
      "topics" => ['0x12341234bf4b564f'],
      "to" =>
        "0x04f96a5e25610293e42a73908e93ccc8c4d4dc0edcfa9fa872f50cb214e08ebf61a03e245533f97284d442460f2998cd41858798ddfd4d661997d3940272b717b1"
    }

    Helpers.check("shh_new_filter", [params])
  end

  test ".shh_uninstall_filter/1",
    do: Helpers.check("shh_uninstall_filter", ["0x7"])

  test ".shh_get_filter_changes/1",
    do: Helpers.check("shh_get_filter_changes", ["0x7"])

  test ".shh_get_messages/1",
    do: Helpers.check("shh_get_messages", ["0x7"])

  describe ".batch_request/1" do
    test "increases rpc_counter by request count" do
      _ = Ethereumex.Counter.increment(:rpc_counter, 42, "stub_method")
      initial_count = Ethereumex.Counter.get(:rpc_counter)

      requests = [
        {:web3_client_version, []},
        {:net_version, []},
        {:web3_sha3, ["0x68656c6c6f20776f726c64"]}
      ]

      assert _ = ClientMock.batch_request(requests)

      assert Ethereumex.Counter.get(:rpc_counter) == initial_count + length(requests)
    end
  end

  describe ".format_batch/1" do
    test "formats batch response" do
      batch = [
        %{
          "error" => %{"code" => -32_000, "message" => "execution reverted"},
          "id" => 86,
          "jsonrpc" => "2.0"
        },
        %{
          "result" => 42,
          "id" => 87,
          "jsonrpc" => "2.0"
        },
        %{
          "result" => 50,
          "id" => 85,
          "jsonrpc" => "2.0"
        }
      ]

      assert [
               {:ok, 50},
               {:error, %{"code" => -32_000, "message" => "execution reverted"}},
               {:ok, 42}
             ] = ClientMock.format_batch(batch)
    end
  end
end
