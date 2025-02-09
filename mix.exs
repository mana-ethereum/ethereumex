defmodule Ethereumex.Mixfile do
  use Mix.Project

  @source_url "https://github.com/exthereum/ethereumex"
  @version "0.10.7"

  def project do
    [
      app: :ethereumex,
      version: @version,
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      preferred_cli_env: [
        dialyzer: :test
      ],
      dialyzer: [
        flags: [:underspecs, :unknown, :unmatched_returns],
        plt_add_apps: [:mix, :jason, :iex, :logger],
        plt_add_deps: :app_tree
      ]
    ]
  end

  def application do
    [
      env: [],
      extra_applications: [:logger],
      mod: {Ethereumex.Application, []}
    ]
  end

  defp package do
    [
      description: "Elixir JSON-RPC client for the Ethereum blockchain",
      maintainers: ["Ayrat Badykov", "Izel Nakri", "Geoff Hayes"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/exthereum/ethereumex"}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.16"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.10", only: :test},
      {:poolboy, "~> 1.5"},
      {:telemetry, "~> 0.4 or ~> 1.0"},
      {:websockex, "~> 0.4.3"},
      {:with_env, "~> 0.1", only: :test}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      formatters: ["html"]
    ]
  end
end
