defmodule Ethereumex do
  use Application
  @moduledoc File.read!("#{__DIR__}/../README.md")

  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = setup_children()

    opts = [strategy: :one_for_one, name: Ethereumex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def setup_children do
    setup_children(Ethereumex.Config.client_type())
  end

  def setup_children(:ipc) do
    path = Enum.join([System.user_home!(), Ethereumex.Config.ipc_path()])

    [
      worker(Ethereumex.WebSocketServer, [Ethereumex.Config.web3_url()]),
      worker(Ethereumex.WebSocketClient, []),
      worker(Ethereumex.IpcServer, [%{path: path}]),
      worker(Ethereumex.IpcClient, [])
    ]
  end

  def setup_children(:http) do
    [worker(Ethereumex.HttpClient, [])]
  end

  def setup_children(opt) do
    raise "Invalid :client option (#{opt}) in config"
  end
end
