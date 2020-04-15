defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.BaseClient
  alias Ethereumex.IpcServer
  @moduledoc false
  @timeout 60_000
  @spec post_request(binary(), []) :: {:ok | :error, any()}
  def post_request(payload, _opts) do
    with {:ok, response} <- call_ipc(payload),
         {:ok, decoded_body} <- Jason.decode(response) do
      case decoded_body do
        %{"error" => error} -> {:error, error}
        result = [%{} | _] -> {:ok, format_batch(result)}
        result -> {:ok, Map.get(result, "result")}
      end
    else
      {:error, %Jason.DecodeError{data: ""}} -> {:error, :empty_response}
      {:error, %Jason.DecodeError{} = error} -> {:error, {:invalid_json, error}}
      {:error, error} -> {:error, error}
    end
  end

  defp call_ipc(payload) do
    :poolboy.transaction(:ipc_worker, fn pid -> IpcServer.post(pid, payload) end, @timeout)
  end
end
