defmodule Ethereumex.HttpClient do
  @moduledoc false

  use Ethereumex.Client.BaseClient
  alias Ethereumex.Config

  @type opt :: {:url, String.t()}
  @type empty_response :: :empty_response
  @type invalid_json :: {:invalid_json, any()}
  @type http_client_error :: {:error, empty_response() | invalid_json() | any()}

  @spec post_request(binary(), [opt()]) :: {:ok, any()} | http_client_error()
  def post_request(payload, opts) do
    headers = Config.http_headers()
    url = Keyword.get(opts, :url) || Config.rpc_url()
    request = Finch.build(:post, url, headers, payload)

    case Finch.request(request, EthereumexFinch, Config.http_options()) do
      {:ok, %Finch.Response{body: body, status: code}} ->
        decode_body(body, code)

      {:error, error} ->
        {:error, error}
    end
  end

  @spec decode_body(binary(), non_neg_integer()) :: {:ok, any()} | http_client_error()
  defp decode_body(body, code) do
    case Jason.decode(body) do
      {:ok, decoded_body} ->
        case {code, decoded_body} do
          {200, %{"error" => error}} -> {:error, error}
          {200, result = [%{} | _]} -> {:ok, format_batch(result)}
          {200, %{"result" => result}} -> {:ok, result}
          _ -> {:error, decoded_body}
        end

      {:error, %Jason.DecodeError{data: ""}} ->
        {:error, :empty_response}

      {:error, error} ->
        {:error, {:invalid_json, error}}
    end
  end
end
