defmodule Ethereumex do
  use Application
  @moduledoc File.read!("#{__DIR__}/../README.md")

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Ethereumex.HttpClient, []),
    ]

    opts = [strategy: :one_for_one, name: Ethereumex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
