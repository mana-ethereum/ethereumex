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
    def check_simple_method(method) do
      method
      |> make_tuple
      |> assert_method
    end

    def assert_method({ex_method, eth_method}) do
      {^eth_method, []} = apply(ClientMock, String.to_atom(ex_method), [])
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

  describe "methods w/o params ... /0" do
    test ".web3_client_version/0", do: Helpers.check_simple_method("web3_client_version")
    test ".net_version/0", do: Helpers.check_simple_method("net_version")
    test ".net_peer_count/0", do: Helpers.check_simple_method("net_peer_count")
    test ".net_listening/0", do: Helpers.check_simple_method("net_listening")
    test ".eth_protocol_version/0", do: Helpers.check_simple_method("eth_protocol_version")
    test ".eth_syncing/0", do: Helpers.check_simple_method("eth_syncing")
    test ".eth_coinbase/0", do: Helpers.check_simple_method("eth_coinbase")
    test ".eth_mining/0", do: Helpers.check_simple_method("eth_mining")
    test ".eth_hashrate/0", do: Helpers.check_simple_method("eth_hashrate")
    test ".eth_gas_price/0", do: Helpers.check_simple_method("eth_gas_price")
    test ".eth_accounts/0", do: Helpers.check_simple_method("eth_accounts")
    test ".eth_block_number/0", do: Helpers.check_simple_method("eth_block_number")
    test ".eth_get_compilers/0", do: Helpers.check_simple_method("eth_get_compilers")
    test ".eth_new_block_filter/0", do: Helpers.check_simple_method("eth_new_block_filter")

    test ".eth_new_pending_transaction_filter/0",
      do: Helpers.check_simple_method("eth_new_pending_transaction_filter")

    test ".eth_get_work/0", do: Helpers.check_simple_method("eth_get_work")
    test ".shh_version/0", do: Helpers.check_simple_method("shh_version")
    test ".shh_new_identity/0", do: Helpers.check_simple_method("shh_new_identity")
    test ".shh_new_group/0", do: Helpers.check_simple_method("shh_new_group")
  end

  describe ".web3_sha3/1" do
    test "returns correct params" do
      string = "string to be hashed"

      {"web3_sha3", [string]} = ClientMock.web3_sha3(string)
    end
  end
end
