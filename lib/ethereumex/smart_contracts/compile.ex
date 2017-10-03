defmodule Ethereumex.SmartContracts.Compile do
  @moduledoc false

  alias Ethereumex.HttpClient

  @spec execute(binary, atom) :: {:ok | :error, any}
  def execute(contract_path, language \\ :solidity) do
    contract_path
    |> read_file
    |> compile_request(language)
  end

  @spec read_file(path :: binary) :: {:ok, binary} | {:error, atom}
  defp read_file(path) do
    path |> File.read
  end

  @spec compile_request({:ok, binary}, :solidity) :: {:ok, binary} | {:error, any}
  defp compile_request({:ok, contract_string}, :solidity) do
    [contract_string]
    |> HttpClient.eth_compile_solidity()
    |> handle_compilation_response
  end

  @spec compile_request({:ok, binary}, :serpent) :: {:ok, binary} | {:error, any}
  defp compile_request({:ok, contract_string}, :serpent) do
    [contract_string]
    |> HttpClient.eth_compile_serpent()
    |> handle_compilation_response
  end

  @spec compile_request({:error, any}, atom) :: {:error, any}
  defp compile_request({:error, description}, _) do
    {:error, description}
  end

  @spec handle_compilation_response({atom, any}) :: {:ok, binary} | {:error, any}
  defp handle_compilation_response(response) do
    case response do
      {:ok, %{"result" => result}} -> {:ok, result}
      {:error, description}        -> {:error, description}
    end
  end
end
