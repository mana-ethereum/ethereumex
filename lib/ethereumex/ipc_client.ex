defmodule Ethereumex.IpcClient do
  use Ethereumex.Client.Macro
  import Ethereumex.Config
  @moduledoc false

  @spec single_request(map(), []) :: {:ok, any() | [any()]} | error
  def single_request(payload, opts \\ []) do
    payload
    |> encode_payload
    |> post_request(opts)
  end

  @spec encode_payload(map()) :: binary()
  defp encode_payload(payload) do
    payload |> Poison.encode!()
  end

  @spec post_request(binary(), []) :: {:ok | :error, any()}
  defp post_request(payload, opts) do
    
    with {:ok, response} <- Ethereumex.IpcServer.post(payload) do
      decoded = Poison.decode(response)
      
      case decoded do
	{:ok, result = [%{} | _]} -> {:ok, format_batch(result)}
	{:ok, result} -> {:ok, Map.get(result, "result")}
	{:error, error} -> {:error, {:invalid_json, error}}
      end
      
    end    
  end

  @spec decode_body(binary()) :: {:ok | :error, any()}
  defp decode_body(body) do
    with {:ok, decoded_body} <- Poison.decode(body) do
      case decoded_body do
        %{"error" => error} -> {:error, error}
        result = [%{} | _] -> {:ok, format_batch(result)}
        %{"result" => result} -> {:ok, result}
        _ -> {:error, decoded_body}
      end
    else
      {:error, error} -> {:error, {:invalid_json, error}}
    end
  end

  @spec format_batch([map()]) :: [map() | nil | binary()]
  defp format_batch(list) do
    list
    |> Enum.sort(fn %{"id" => id1}, %{"id" => id2} ->
      id1 <= id2
    end)
    |> Enum.map(fn %{"result" => result} ->
      result
    end)
  end
end
