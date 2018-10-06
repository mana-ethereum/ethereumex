use Mix.Config

config :ethereumex, request_timeout: 5000

import_config "#{Mix.env()}.exs"
