defmodule Ethereumex.Client.MacroTest do
  use ExUnit.Case

  defmodule ClientMock do
    use Ethereumex.Client.Macro

    def single_request(payload) do
      %{"method" => method, "jsonrpc" => "2.0", "params" => params} = payload

      {method, params}
    end
  end

  setup_all do
    ClientMock.start_link()

    :ok
  end

  describe ".web3_client_version/0" do
    test "returns correct params" do
      result = ClientMock.web3_client_version()

      {"web3_clientVersion", []} = result
    end
  end

  describe ".web3_sha3/1" do
    test "returns correct params" do
      string = "string to be hashed"
      result = ClientMock.web3_sha3(string)

      {"web3_sha3", [string]} = result
    end
  end

  describe ".net_version/0" do
    test "returns correct params" do
      result = ClientMock.net_version()

      {"net_version", []} = result
    end
  end
end
