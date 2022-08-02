defmodule Ethereumex.HttpClient do
  @moduledoc false

  use Ethereumex.Client.BaseClient

  alias Ethereumex.Config

  @type empty_response :: :empty_response
  @type invalid_json :: {:invalid_json, any()}
  @type http_client_error :: {:error, empty_response() | invalid_json() | any()}

  @spec post_request(binary(), Keyword.t()) :: {:ok, any()} | http_client_error()
  def post_request(payload, opts) do
    headers = Keyword.get(opts, :http_headers) || Config.http_headers()
    url = Keyword.get(opts, :url) || Config.rpc_url()

    format_batch =
      case Keyword.get(opts, :format_batch) do
        nil -> Config.format_batch()
        value -> value
      end

    request = Finch.build(:post, url, headers, payload)

    case Finch.request(request, Ethereumex.Finch, Config.http_options()) do
      {:ok, %Finch.Response{body: body, status: code}} ->
        decode_body(body, code, format_batch)

      {:error, error} ->
        {:error, error}
    end
  end

  @spec decode_body(binary(), non_neg_integer(), boolean()) :: {:ok, any()} | http_client_error()
  defp decode_body(body, code, format_batch) do
    case Jason.decode(body) do
      {:ok, decoded_body} ->
        case {code, decoded_body} do
          {200, %{"error" => error}} ->
            {:error, error}

          {200, result = [%{} | _]} ->
            {:ok, maybe_format_batch(result, format_batch)}

          {200, %{"result" => result}} ->
            {:ok, result}

          _ ->
            {:error, decoded_body}
        end

      {:error, %Jason.DecodeError{data: ""}} ->
        {:error, :empty_response}

      {:error, error} ->
        {:error, {:invalid_json, error}}
    end
  end

  defp maybe_format_batch(responses, true), do: format_batch(responses)

  defp maybe_format_batch(responses, _), do: responses
end
