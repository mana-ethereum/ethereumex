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

  @spec client_type() :: atom()
  def client_type do
    Application.get_env(:ethereumex, :client_type, :http)
  end

  @spec ipc_path() :: binary()
  def ipc_path do
    case Application.get_env(:ethereumex, :ipc_path, "") do
      path when is_binary(path) and path != "" ->
        path

      not_a_path ->
        raise ArgumentError,
          message:
            "Please set config variable `config :ethereumex, :ipc_path, \"path/to/ipc\", got `#{
              not_a_path
            }`. Note: System.user_home! will be prepended to path for you on initialization"
    end
  end
end
