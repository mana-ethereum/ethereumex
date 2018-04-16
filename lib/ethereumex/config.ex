defmodule Ethereumex.Config do
  @moduledoc false

  @spec rpc_url() :: binary()
  def rpc_url do
    case Application.get_env(:ethereumex, :url) do
      url when is_binary(url) and url != "" ->
        url

      els ->
        raise ArgumentError,
          message:
            "Please set config variable `config :ethereumex, :url, \"http://...\", got: `#{
              inspect(els)
            }``"
    end
  end

  @spec http_options() :: keyword()
  def http_options do
    Application.get_env(:ethereumex, :http_options, [])
  end
end
