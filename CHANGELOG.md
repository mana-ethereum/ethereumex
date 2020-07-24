# 0.6.3
* Fix request id exhaustion due to exponential increment (https://github.com/mana-ethereum/ethereumex/pull/76)

# 0.6.2
* Make `telemetry` required dependency (https://github.com/mana-ethereum/ethereumex/pull/73)

# 0.6.1
* Dependency updates: :httpoison 1.4 -> 1.6, :jason 1.1 -> 1.2, :credo 0.10.2 -> 1.3, :ex_doc 0.19 -> 0.21, :dialyxir 1.0.0-rc.7 -> 1.0.0. And small refactors according to Credo. https://github.com/mana-ethereum/ethereumex/pull/69

# 0.6.0
* Deprecate measurements via adapter for :telemetry. https://github.com/mana-ethereum/ethereumex/pull/68

# 0.5.6
* Feature that allows measuring number of RPC calls via an adapter https://github.com/mana-ethereum/ethereumex/pull/67

# 0.5.5
* Allow request counter resetting (https://github.com/mana-ethereum/ethereumex/pull/65)

# 0.5.4
* Reported issue with dialyzer specs for boolean arguments in params (https://github.com/mana-ethereum/ethereumex/pull/61)

# 0.5.3
* Add special case for empty response (https://github.com/mana-ethereum/ethereumex/pull/59)

# 0.5.2
* Fix `eth_estimateGas` (https://github.com/mana-ethereum/ethereumex/pull/55)
* Add `eth_getProof` (https://github.com/mana-ethereum/ethereumex/pull/57)

# 0.5.1
* Replaced poison with jason (https://github.com/mana-ethereum/ethereumex/pull/50)
* Upgraded httpoison to v1.4 (https://github.com/mana-ethereum/ethereumex/pull/50)

# 0.5.0
* Remove tunneling requests (https://github.com/exthereum/ethereumex/pull/46)
* Use poolboy for IpcClient (https://github.com/exthereum/ethereumex/pull/47)

# 0.4.0
* Use IPC with IpcClient. Choose client type based on config :client_type (https://github.com/exthereum/ethereumex/pull/40)
* Update poison, credo, dialyzer (https://github.com/exthereum/ethereumex/pull/42)

# 0.3.4
* Allow configuring GenServer timeout for requests (https://github.com/exthereum/ethereumex/pull/39)

# 0.3.3
* Added dynamic url input(https://github.com/exthereum/ethereumex/pull/37)

# 0.3.2
* Fix eth_getLogs mathod params (https://github.com/exthereum/ethereumex/pull/20)

# 0.3.1
* Handle failed HTTP requests more gracefully (https://github.com/exthereum/ethereumex/pull/19)

# 0.3.0
* Breaking: Use `:url` config variable instead of `:host`, `:port` and `:scheme` (https://github.com/exthereum/ethereumex/pull/13)

# 0.2.0
* Breaking: explicit parameters (https://github.com/exthereum/ethereumex/pull/10)

# 0.1.2
* Added generic request method (https://github.com/exthereum/ethereumex/pull/4)

# 0.1.1
* Added necessary JSON header for parity (https://github.com/exthereum/ethereumex/pull/2)
