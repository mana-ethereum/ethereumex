defmodule Ethereumex.SmartContracts.CompileTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Ethereumex.SmartContracts.Compile
  alias Ethereumex.HttpClient

  setup_all do
    HttpClient.start_link

    :ok
  end

  test "compiles solidity smart contract" do
    use_cassette "smart_contracts_compile_solidity" do
      path = File.cwd!
        |> List.wrap
        |> Kernel.++(["test", "support", "test_contract.sol"])
        |> Path.join
      expected_compiled_contract = "0x6060604052341561" <>
        "000f57600080fd5b60b38061001d6000396000f3006060604052" <>
        "63ffffffff7c0100000000000000000000000000000000000000" <>
        "00000000000000000060003504166360fe47b181146045578063" <>
        "6d4ce63c14605a57600080fd5b3415604f57600080fd5b605860" <>
        "0435607c565b005b3415606457600080fd5b606a6081565b6040" <>
        "5190815260200160405180910390f35b600055565b6000549056" <>
        "00a165627a7a7230582033edcee10845eead909dccb4e95bb7e4" <>
        "062e92234bf3cfaf804edbd265e599800029"

      {:ok, ^expected_compiled_contract} = Compile.execute(path)
    end
  end

  test "fails when wrong path is provided" do
    path = "wrong path"

    {:error, :enoent} = Compile.execute(path)
  end

  test "fails when can't connect to json rpc host" do
    use_cassette "smart_contracts_compile_failed_connection" do
      path = File.cwd!
        |> List.wrap
        |> Kernel.++(["test", "support", "test_contract.sol"])
        |> Path.join

      {:error, "econnrefused"} = Compile.execute(path)
    end
  end
end
