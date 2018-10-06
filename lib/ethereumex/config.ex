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

  @spec request_timeout() :: integer()
  def request_timeout do
    Application.get_env(:ethereumex, :request_timeout, 5000)
  end

  def client_type do
    Application.get_env(:ethereumex, :client_type, :http)
  end

  def ipc_path do
    Application.get_env(:ethereumex, :ipc_path, "/")
  end
end
