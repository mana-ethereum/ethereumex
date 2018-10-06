use Mix.Config

config :ethereumex, request_timeout: 5000

config :ethereumex, :client, :ipc

config :ethereumex, :ipc_path, "/.local/share/io.parity.ethereum/jsonrpc.ipc"

import_config "#{Mix.env()}.exs"
