defmodule Ethereumex.SmartContracts.Deploy do
  @moduledoc false

  alias Ethereumex.HttpClient

  defmodule Error do
    defexception message: nil, value: nil
  end

  @spec execute(binary, keyword) :: binary
  def execute(compiled_contract, opts \\ []) do
    from = opts[:from] |> prepare_from_value
    gas = opts[:gas] |> prepare_gas_value(compiled_contract, from)

    send_transaction(compiled_contract, from, gas)
  end

  @spec send_transaction(binary, binary, binary) :: binary
  defp send_transaction(compiled_contract, from, gas) do
    response =
      [%{from: from, gas: gas, data: compiled_contract}]
      |> HttpClient.eth_send_transaction()

    case response do
      {:ok, %{"result" => result}} -> result
      other ->
        raise Error, value: other,
          message: "Could not send eth_send_transaction request"
    end
  end

  @spec prepare_from_value(binary) :: binary
  defp prepare_from_value(from) do
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
    case HttpClient.eth_coinbase do
      {:ok, %{"result" => result}} -> result
      other ->
        raise Error, value: other,
              message: "Could not send coinbase request"
    end
  end

  @spec estimated_gas(binary, binary) :: binary
  defp estimated_gas(compiled_contract, from) do
    response =
      [%{from: from, data: compiled_contract}]
      |> HttpClient.eth_estimate_gas

    case response do
      {:ok, %{"result" => result}} -> result
      other ->
        raise Error, value: other,
          message: "Could not send eth_estimate_gas request"
    end
  end
end
