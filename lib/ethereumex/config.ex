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

  def setup_children do
    setup_children(Application.get_env(:ethereumex, :client, :http))
  end

  def setup_children(:ipc) do
    path = Enum.join([System.user_home!(), Application.get_env(:ethereumex, :ipc_path, "/")])

    [
      Supervisor.Spec.worker(Ethereumex.IpcServer, [%{path: path}]),
      Supervisor.Spec.worker(Ethereumex.IpcClient, [])
    ]
  end

  def setup_children(:http) do
    [ Supervisor.Spec.worker(Ethereumex.HttpClient, []) ]
  end

  def setup_children(opt) do
    raise "Invalid :client option (#{opt}) in config"
  end
end
