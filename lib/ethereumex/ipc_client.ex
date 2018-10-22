defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.BaseClient

  @moduledoc false

  @spec post_request(binary(), [], integer()) :: {:ok | :error, any()}
  def post_request(payload, _opts, _request_id) do
    with {:ok, response} <- Ethereumex.IpcServer.post(payload) do
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
