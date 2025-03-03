defmodule Ethereumex.IpcClient do
  @moduledoc false

  use Ethereumex.Client.BaseClient

  alias Ethereumex.Config
  alias Ethereumex.IpcServer

  @timeout 60_000
  @spec post_request(binary(), []) :: {:ok | :error, any()}
  def post_request(payload, _opts) do
    with {:ok, response} <- call_ipc(payload),
         {:ok, decoded_body} <- jason_decode(response) do
      case decoded_body do
        %{"error" => error} -> {:error, error}
        result = [%{} | _] -> {:ok, format_batch(result)}
        result -> {:ok, Map.get(result, "result")}
      end
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp call_ipc(payload) do
    :poolboy.transaction(:ipc_worker, fn pid -> IpcServer.post(pid, payload) end, @timeout)
  end

  defp jason_decode(response) do
    case Config.json_module().decode(response) do
      {:ok, _result} = result -> result
      {:error, error} -> {:error, {:decode_error, error}}
    end
  end
end
