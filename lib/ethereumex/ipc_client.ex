defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.Macro
  use Ethereumex.Client.BaseClient
  #import Ethereumex.Config
  @moduledoc false  

  @spec post_request(binary(), []) :: {:ok | :error, any()}
  def post_request(payload, _opts) do
    with {:ok, response} <- Ethereumex.IpcServer.post(payload) do
      decoded = Poison.decode(response)

      case decoded do
        {:ok, result = [%{} | _]} -> {:ok, format_batch(result)}
        {:ok, result} -> {:ok, Map.get(result, "result")}
        {:error, error} -> {:error, {:invalid_json, error}}
      end
    else
      {:error, error} -> {:error, error}
    end
  end

end
