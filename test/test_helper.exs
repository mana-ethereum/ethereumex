ExUnit.configure(
  exclude: [
    :skip,
    :web3,
    :net,
    :eth,
    :eth_mine,
    :eth_db,
    :shh,
    :eth_compile,
    :eth_sign,
    :batch,
    :eth_chain_id
  ]
)

Mimic.copy(WebSockex)
Mimic.copy(Ethereumex.WebsocketServer)

Application.ensure_all_started(:telemetry)
ExUnit.start()
