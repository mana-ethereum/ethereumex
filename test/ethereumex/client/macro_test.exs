defmodule Ethereumex.Client.MacroTest do
  use ExUnit.Case

  defmodule ClientMock do
    use Ethereumex.Client.Macro

    def single_request(payload) do
      %{"method" => method, "jsonrpc" => "2.0", "params" => params} = payload

      {method, params}
    end
  end

  defmodule Helpers do
    def check(method, params \\ [], defaults \\ []) do
      method
      |> make_tuple
      |> assert_method(params, params ++ defaults)
    end

    def assert_method({ex_method, eth_method}, params, payload) do
      {^eth_method, ^payload} = apply(ClientMock, String.to_atom(ex_method), params)
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
      uppered =
        tail
        |> Enum.map(&String.capitalize/1)
        |> Enum.join()

      Enum.join([first, second], "_") <> uppered
    end
  end

  setup_all do
    ClientMock.start_link()

    :ok
  end

  @address "0x407d73d8a49eeb85d32cf465507dd71d507100c1"

  test ".web3_client_version/0", do: Helpers.check("web3_client_version")
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

  test ".eth_get_work/0", do: Helpers.check("eth_get_work")
  test ".shh_version/0", do: Helpers.check("shh_version")
  test ".shh_new_identity/0", do: Helpers.check("shh_new_identity")
  test ".shh_new_group/0", do: Helpers.check("shh_new_group")

  test ".web3_sha3/1", do: Helpers.check("web3_sha3", ["string to be hashed"])

  test ".eth_get_balance/1",
    do: Helpers.check("eth_get_balance", [@address], ["latest"])

  test ".eth_get_storage_at/1",
    do: Helpers.check("eth_get_storage_at", [@address, "0x0"], ["latest"])

  test ".eth_get_transaction_count/1",
    do: Helpers.check("eth_get_transaction_count", [@address], ["latest"])

  test ".eth_get_block_transaction_count_by_hash/1" do
    Helpers.check("eth_get_block_transaction_count_by_hash", [
      "0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238"
    ])
  end
end
