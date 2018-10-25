defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.BaseClient
  alias Ethereumex.IpcServer
  @moduledoc false

  @spec post_request(binary(), []) :: {:ok | :error, any()}
  def post_request(payload, _opts) do
    with {:ok, response} <- IpcServer.post(payload) do
      with {:ok, decoded_body} <- Poison.decode(response) do
        case decoded_body do
          %{"error" => error} -> {:error, error}
          result = [%{} | _] -> {:ok, format_batch(result)}
          result -> {:ok, Map.get(result, "result")}
        end
      else
        {:error, error} -> {:error, {:invalid_json, error}}
      end
    else
      {:error, error} -> {:error, error}
    end
  end
end
