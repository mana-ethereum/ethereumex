defmodule Ethereumex.SmartContracts do
  alias Ethereumex.HttpClient

  @spec compile(binary, atom) :: {:ok | :error, any}
  def compile(contract_path, language \\ :solidity) do
    contract_path
    |> read_file
    |> compile_request(language)
  end

  @spec deploy(binary, keyword) :: binary
  def deploy(compiled_contract, opts \\ []) do
    from = if is_nil(opts[:from]), do: coinbase(), else: opts[:from]
    gas = if is_nil(opts[:gas]) do
        estimated_gas(compiled_contract, from)
      else
        opts[:gas]
      end

    {:ok, %{result: result}} =
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

  @spec read_file(path :: binary) :: binary
  defp read_file(path) do
    {:ok, contract_string} = path |> File.read

    contract_string
  end

  @spec compile_request(binary, :solidity) :: {:ok | :error, any}
  defp compile_request(contract_string, :solidity) do
    HttpClient.eth_compile_solidity([contract_string])
  end

  @spec compile_request(binary, :serpent) :: {:ok | :error, any}
  defp compile_request(contract_string, :serpent) do
    HttpClient.eth_compile_serpent([contract_string])
  end
end
