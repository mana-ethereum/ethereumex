defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.Macro
  import Ethereumex.Config
  @moduledoc false

  @spec single_request(map()) :: {:ok, any() | [and()]} | error
  def single_request(payload) do
    payload
    |> encode_payload
    |> post_request
  end

  @@spec encode_payload(map()) :: binary()
  defp encode_payload(payload) do
    payload |> Poison.encode!()
  end

  @@spec post_request(binary()) :: {:ok | :error, any()}
  defp post_request(payload) do
    options = Ethereumex.Config.ipc_options()

    with {:ok, response} <-

  end
