use Mix.Config
config :ethereumex,
  scheme: System.get_env("ETHEREUM_SCHEME"),
  host: System.get_env("ETHEREUM_HOST"),
  port: System.get_env("ETHEREUM_PORT")
