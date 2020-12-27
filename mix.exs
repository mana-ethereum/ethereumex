defmodule Ethereumex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ethereumex,
      version: "0.6.4",
      elixir: "~> 1.7",
      description: "Elixir JSON-RPC client for the Ethereum blockchain",
      package: [
        maintainers: ["Ayrat Badykov", "Izel Nakri", "Geoff Hayes"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/exthereum/ethereumex"}
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        dialyzer: :test
      ],
      dialyzer: [
        flags: [:underspecs, :unknown, :unmatched_returns],
        plt_add_apps: [:mix, :jason, :iex, :logger],
        plt_add_deps: :transitive
      ]
    ]
  end

  def application do
    [
      env: [],
      extra_applications: [:logger],
      mod: {Ethereumex, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:poolboy, "~> 1.5.1"},
      {:telemetry, "~> 0.4"},
      {:with_env, "~> 0.1", only: :test}
    ]
  end
end
