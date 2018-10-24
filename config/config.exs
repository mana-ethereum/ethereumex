use Mix.Config

config :ethereumex, request_timeout: 5000
# config :ethereumex, ipc_path: "/Library/Application Support/io.parity.ethereum/jsonrpc.ipc"
import_config "#{Mix.env()}.exs"
