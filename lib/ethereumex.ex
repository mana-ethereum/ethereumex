defmodule Ethereumex do
  use Application
  alias Ethereumex.Counter
  alias Ethereumex.Config
  @moduledoc File.read!("#{__DIR__}/../README.md")
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    :ok = Counter.setup()
    children = Config.setup_children()
    opts = [strategy: :one_for_one, name: Ethereumex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
