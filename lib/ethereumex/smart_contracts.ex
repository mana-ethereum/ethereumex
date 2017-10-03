defmodule Ethereumex.SmartContracts do
  @moduledoc """
  A module that contains functionality for working with smart contracts.
  """
  alias Ethereumex.SmartContracts.{Compile, Deploy}

  @doc """
  Compiles smart contract written in solidity or serpent.
  """

  @spec compile(binary, atom) :: {:ok, binary} | {:error, any}
  def compile(contract_path, language \\ :solidity) do
    Compile.execute(contract_path, language)
  end

  @spec deploy(binary, keyword) :: binary | {:error, any}
  def deploy(compiled_contract, opts \\ []) do
    Deploy.execute(compiled_contract, opts)
  end
end
