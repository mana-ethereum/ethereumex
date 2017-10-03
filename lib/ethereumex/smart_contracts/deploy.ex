defmodule Ethereumex.SmartContracts.Deploy do
  @moduledoc false

  alias Ethereumex.HttpClient

  @spec execute(binary, keyword) :: binary
  def execute(compiled_contract, opts \\ []) do
    from = opts[:from] |> prepare_from_value
    gas = opts[:gas] |> prepare_gas_value(compiled_contract, from)

    send_transaction(compiled_contract, from, gas)
  end

  @spec send_transaction(binary, binary, binary) :: binary
  defp send_transaction(compiled_contract, from, gas) do
    {:ok, %{"result" => result}} =
      [%{from: from, gas: gas, data: compiled_contract}]
      |> HttpClient.eth_send_transaction()

    result
  end

  @spec prepare_from_value(binary) :: binary
  def prepare_from_value(from) do
    case from do
      nil        -> coinbase()
      from_value -> from_value
    end
  end

  @spec prepare_gas_value(binary, binary, binary) :: binary
  defp prepare_gas_value(gas, compiled_contract, from) do
    case gas do
      nil       -> estimated_gas(compiled_contract, from)
      gas_value -> gas_value
    end
  end

  @spec coinbase() :: binary
  defp coinbase do
    {:ok, %{"result" => result}} = HttpClient.eth_coinbase

    result
  end

  @spec estimated_gas(binary, binary) :: binary
  defp estimated_gas(compiled_contract, from) do
    {:ok, %{"result" => result}} =
      [%{from: from, data: compiled_contract}]
      |> HttpClient.eth_estimate_gas

    result
  end
end
