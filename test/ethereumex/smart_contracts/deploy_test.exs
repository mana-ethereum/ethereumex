defmodule Ethereumex.SmartContracts.DeployTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Ethereumex.SmartContracts.Deploy
  alias Ethereumex.HttpClient

  setup_all do
    HttpClient.start_link

    :ok
  end

  test "deploy smart contract" do
    use_cassette "smart_contracts_deploy" do
      compiled_contract = "0x6060604052341561" <>
        "000f57600080fd5b60b38061001d6000396000f3006060604052" <>
        "63ffffffff7c0100000000000000000000000000000000000000" <>
        "00000000000000000060003504166360fe47b181146045578063" <>
        "6d4ce63c14605a57600080fd5b3415604f57600080fd5b605860" <>
        "0435607c565b005b3415606457600080fd5b606a6081565b6040" <>
        "5190815260200160405180910390f35b600055565b6000549056" <>
        "00a165627a7a7230582033edcee10845eead909dccb4e95bb7e4" <>
        "062e92234bf3cfaf804edbd265e599800029"
      from = "0x001bdcde60cb916377a3a3bf4e8054051a4d02e7"

      result = Deploy.execute(compiled_contract, from: from)

      assert "0x187b2" == result
    end
  end
end
