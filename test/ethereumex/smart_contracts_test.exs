defmodule Ethereumex.SmartContractsTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Ethereumex.{SmartContracts, HttpClient}

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

      result = SmartContracts.compile(path)

      {:ok,
       %{"id" => 5,
         "jsonrpc" => "2.0",
         "result" => "0x6060604052341561000f57600080fd5b60b38061001d6000396000f300606060405263ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166360fe47b1811460455780636d4ce63c14605a57600080fd5b3415604f57600080fd5b6058600435607c565b005b3415606457600080fd5b606a6081565b60405190815260200160405180910390f35b600055565b600054905600a165627a7a7230582033edcee10845eead909dccb4e95bb7e4062e92234bf3cfaf804edbd265e599800029"}
      } = result
    end
  end
end
