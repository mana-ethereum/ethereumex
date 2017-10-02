defmodule Ethereumex.SmartContracts do
  alias Ethereumex.HttpClient

  @spec compile(binary, atom) :: {:ok | :error, any}
  def compile(contract_path, language \\ :solidity) do
    contract_path
    |> read_file
    |> compile_request(language)
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
