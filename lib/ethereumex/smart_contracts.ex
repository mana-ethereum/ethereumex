defmodule Ethereumex.SmartContracts do
  @moduledoc """
  A module that contains functionality for working with smart contracts.
  """

  alias Ethereumex.HttpClient
  alias Ethereumex.SmartContracts.Compile

  @doc """
  Compiles smart contract written in solidity or serpent.
  """

  @spec compile(binary, atom) :: {:ok, binary} | {:error, any}
  def compile(contract_path, language \\ :solidity) do
    Compile.execute(contract_path, language)
  end

  @spec deploy(binary, keyword) :: binary
  def deploy(compiled_contract, opts \\ []) do
    from = if is_nil(opts[:from]), do: coinbase(), else: opts[:from]
    gas = if is_nil(opts[:gas]) do
        estimated_gas(compiled_contract, from)
      else
        opts[:gas]
      end

    {:ok, %{"result" => result}} =
      [%{from: from, gas: gas, data: compiled_contract}]
      |> HttpClient.eth_send_transaction()

    result
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
