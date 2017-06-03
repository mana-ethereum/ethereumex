defmodule Ethereumex.Mixfile do
  use Mix.Project

  def project do
    [app: :ethereumex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.1"},
     {:poison, "~> 3.1.0"},
     {:credo, "~> 0.8", only: [:dev, :test], runtime: false}]
  end
end
