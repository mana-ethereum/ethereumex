# Changelog

## 0.9.0 - 2021-12-25
* Allow adding custom headers (https://github.com/mana-ethereum/ethereumex/pull/97)
* Handle errors in batch requests (https://github.com/mana-ethereum/ethereumex/pull/98)

## 0.8.0 - 2021-11-21
* Switch from `httpoison` to `finch` (https://github.com/mana-ethereum/ethereumex/pull/94)

## 0.7.1 - 2021-10-10
* Change telemetry version (https://github.com/mana-ethereum/ethereumex/pull/92)

## 0.7.0 - 2020-12-07
* Remove unremovable default hackney pool (https://github.com/mana-ethereum/ethereumex/pull/82)
* Change ipc_path to absolute path (https://github.com/mana-ethereum/ethereumex/pull/87)
* Bump deps (https://github.com/mana-ethereum/ethereumex/pull/88)
* Config.setup_children can inject client type (https://github.com/mana-ethereum/ethereumex/pull/83)
* Improve typespecs (https://github.com/mana-ethereum/ethereumex/pull/80, https://github.com/mana-ethereum/ethereumex/pull/85, https://github.com/mana-ethereum/ethereumex/pull/86)

## 0.6.4 - 2020-07-24
* Fix request id exhaustion due to exponential increment (https://github.com/mana-ethereum/ethereumex/pull/76)

## 0.6.3 - 2020-06-30
* Make batch requests support configurable url via opts argument (https://github.com/mana-ethereum/ethereumex/pull/77)

## 0.6.2 - 2020-05-27
* Make `telemetry` required dependency (https://github.com/mana-ethereum/ethereumex/pull/73)

## 0.6.1 - 2020-04-16
* Dependency updates: :httpoison 1.4 -> 1.6, :jason 1.1 -> 1.2, :credo 0.10.2 -> 1.3, :ex_doc 0.19 -> 0.21, :dialyxir 1.0.0-rc.7 -> 1.0.0. And small refactors according to Credo. https://github.com/mana-ethereum/ethereumex/pull/69

## 0.6.0 - 2020-03-02
* Deprecate measurements via adapter for :telemetry. https://github.com/mana-ethereum/ethereumex/pull/68

## 0.5.6 - 2020-02-28
* Feature that allows measuring number of RPC calls via an adapter https://github.com/mana-ethereum/ethereumex/pull/67

## 0.5.5 - 2020-10-21
* Allow request counter resetting (https://github.com/mana-ethereum/ethereumex/pull/65)

## 0.5.4 - 2020-05-23
* Reported issue with dialyzer specs for boolean arguments in params (https://github.com/mana-ethereum/ethereumex/pull/61)

## 0.5.3 - 2019-02-10
* Add special case for empty response (https://github.com/mana-ethereum/ethereumex/pull/59)

## 0.5.2 - 2018-12-29
* Fix `eth_estimateGas` (https://github.com/mana-ethereum/ethereumex/pull/55)
* Add `eth_getProof` (https://github.com/mana-ethereum/ethereumex/pull/57)

## 0.5.1 - 2018-11-04
* Replaced poison with jason (https://github.com/mana-ethereum/ethereumex/pull/50)
* Upgraded httpoison to v1.4 (https://github.com/mana-ethereum/ethereumex/pull/50)

## 0.5.0 - 2018-10-25
* Remove tunneling requests (https://github.com/exthereum/ethereumex/pull/46)
* Use poolboy for IpcClient (https://github.com/exthereum/ethereumex/pull/47)

## 0.4.0 - 2018-10-27
* Use IPC with IpcClient. Choose client type based on config :client_type (https://github.com/exthereum/ethereumex/pull/40)
* Update poison, credo, dialyzer (https://github.com/exthereum/ethereumex/pull/42)

## 0.3.4 - 2018-09-25
* Allow configuring GenServer timeout for requests (https://github.com/exthereum/ethereumex/pull/39)

## 0.3.3 - 2018-07-31
* Added dynamic url input(https://github.com/exthereum/ethereumex/pull/37)

## 0.3.2 - 2018-03-29
* Fix eth_getLogs mathod params (https://github.com/exthereum/ethereumex/pull/20)

## 0.3.1 - 2018-02-09
* Handle failed HTTP requests more gracefully (https://github.com/exthereum/ethereumex/pull/19)

## 0.3.0 - 2018-01-23
* Breaking: Use `:url` config variable instead of `:host`, `:port` and `:scheme` (https://github.com/exthereum/ethereumex/pull/13)

## 0.2.0 - 2018-10-16
* Breaking: explicit parameters (https://github.com/exthereum/ethereumex/pull/10)

## 0.1.2 - 2017-09-25
* Added generic request method (https://github.com/exthereum/ethereumex/pull/4)

## 0.1.1 - 2017-09-16
* Added necessary JSON header for parity (https://github.com/exthereum/ethereumex/pull/2)
