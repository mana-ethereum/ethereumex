defmodule Ethereumex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ethereumex,
      version: "0.3.4",
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
      dialyzer: [
        flags: [:underspecs, :unknown, :unmatched_returns],
        plt_add_apps: [:mix, :poison, :iex, :logger],
        plt_add_deps: :transitive
      ]
    ]
  end

  def application do
    [
      env: [request_timeout: 5000],
      extra_applications: [:logger],
      mod: {Ethereumex, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.3.1"},
      {:poison, "~> 4.0.1"},
      {:credo, "~> 0.10.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false}
    ]
  end
end
