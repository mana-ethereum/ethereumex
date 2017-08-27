defmodule Ethereumex.HttpClient do
  use Ethereumex.Client
  import Ethereumex.Config
  @moduledoc false

  @spec post_request(map()) :: {:ok | :error, any()}
  def request(payload) do
    payload
    |> encode_payload
    |> post_request
  end

  defp encode_payload(payload) do
    payload |> Poison.encode!
  end

  @spec post_request(binary()) :: {:ok | :error, any()}
  defp post_request(payload) do
    response = rpc_url() |> HTTPoison.post(payload)

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
      {200, %{"error" => error}} -> {:error, error}
      {200, _}                   -> {:ok, decoded_body}
      _                          -> {:error, decoded_body}
    end
  end
end
