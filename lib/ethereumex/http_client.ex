defmodule Ethereumex.HttpClient do
  use Ethereumex.Client.BaseClient
  import Ethereumex.Config
  @moduledoc false

  @spec post_request(binary(), [], integer()) :: {:ok | :error, any()}
  def post_request(payload, opts, _request_id) do
    headers = [{"Content-Type", "application/json"}]
    options = Ethereumex.Config.http_options()
    url = Keyword.get(opts, :url) || web3_url()

    with {:ok, response} <- HTTPoison.post(url, payload, headers, options),
         %HTTPoison.Response{body: body, status_code: code} = response do
      decode_body(body, code)
    else
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      e -> {:error, e}
    end
  end

  @spec decode_body(binary(), integer()) :: {:ok | :error, any()}
  defp decode_body(body, code) do
    with {:ok, decoded_body} <- Poison.decode(body) do
      case {code, decoded_body} do
        {200, %{"error" => error}} -> {:error, error}
        {200, result = [%{} | _]} -> {:ok, format_batch(result)}
        {200, %{"result" => result}} -> {:ok, result}
        _ -> {:error, decoded_body}
      end
    else
      {:error, error} -> {:error, {:invalid_json, error}}
    end
  end
end
