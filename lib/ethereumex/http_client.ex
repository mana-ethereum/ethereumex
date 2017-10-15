defmodule Ethereumex.HttpClient do
  use Ethereumex.Client.Macro
  import Ethereumex.Config
  @moduledoc false

  @spec single_request(map()) :: {:ok, any() | [any()]} | error
  def single_request(payload) do
    payload
    |> encode_payload
    |> post_request
  end

  @spec encode_payload(map()) :: binary()
  defp encode_payload(payload) do
    payload |> Poison.encode!
  end

  @spec post_request(binary()) :: {:ok | :error, any()}
  defp post_request(payload) do
    response = rpc_url() |> HTTPoison.post(payload, [{"Content-Type", "application/json"}])

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        body |> decode_body(code)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec decode_body(binary(), integer()) :: {:ok | :error, any()}
  defp decode_body(body, code) do
    decoded_body = body |> Poison.decode!

    case {code, decoded_body} do
      {200, %{"error" => error}}   -> {:error, error}
      {200, result = [%{}|_]}      -> {:ok, format_batch(result)}
      {200, %{"result" => result}} -> {:ok, result}
      _                            -> {:error, decoded_body}
    end
  end

  @spec format_batch([map()]) :: [map() | nil | binary()]
  defp format_batch(list) do
    list
    |> Enum.sort(fn(%{"id" => id1}, %{"id" => id2}) ->
      id1 <= id2
    end)
    |> Enum.map(fn(%{"result" => result}) ->
      result
    end)
  end
end
