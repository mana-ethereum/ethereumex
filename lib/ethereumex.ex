defmodule Ethereumex do
  use Application
  alias Ethereumex.Counter
  alias Ethereumex.Config
  alias Ethereumex.IpcServer

  @moduledoc File.read!("#{__DIR__}/../README.md")
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    :ok = Counter.setup()
    children = setup_children()
    opts = [strategy: :one_for_one, name: Ethereumex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_children do
    setup_children(Config.client_type())
  end

  defp setup_children(:ipc) do
    path = Enum.join([System.user_home!(), Config.ipc_path()])

    [
      worker(IpcServer, [%{path: path}])
    ]
  end

  defp setup_children(:http) do
    []
  end

  defp setup_children(opt) do
    raise "Invalid :client option (#{opt}) in config"
  end
end
