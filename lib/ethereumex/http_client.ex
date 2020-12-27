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
    headers = [{"Content-Type", "application/json"}]
    options = [hackney: [pool: :default]] ++ Config.http_options()
    url = Keyword.get(opts, :url) || Config.rpc_url()

    case HTTPoison.post(url, payload, headers, options) do
      {:ok, response} ->
        %HTTPoison.Response{body: body, status_code: code} = response
        decode_body(body, code)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @spec decode_body(binary(), integer()) :: {:ok, any()} | http_client_error()
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
