# Ethereumex [![CircleCI](https://circleci.com/gh/exthereum/ethereumex.svg?style=svg)](https://circleci.com/gh/exthereum/ethereumex)

Elixir JSON-RPC client for the Ethereum blockchain

## Installation
Add Ethereumex to your `mix.exs` dependencies:

1. Add `ethereumex` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [{:ethereumex, "~> 0.1.2"}]
end
```

2. Ensure `ethereumex` is started before your application:

```elixir
def application do
  [applications: [:ethereumex]]
end
```

## Configuration

In `config/config.exs`, add Ethereum protocol host params to your config file

```elixir
config :ethereumex,
  scheme: "http",
  host: "localhost",
  port: 8545
```

## Usage

### Available methods:

* web3_clientVersion
* web3_sha3
* net_version
* net_peerCount
* net_listening
* eth_protocolVersion
* eth_syncing
* eth_coinbase
* eth_mining
* eth_hashrate
* eth_gasPrice
* eth_accounts
* eth_blockNumber
* eth_getBalance
* eth_getStorageAt
* eth_getTransactionCount
* eth_getBlockTransactionCountByHash
* eth_getBlockTransactionCountByNumber
* eth_getUncleCountByBlockHash
* eth_getUncleCountByBlockNumber
* eth_getCode
* eth_sign
* eth_sendTransaction
* eth_sendRawTransaction
* eth_call
* eth_estimateGas
* eth_getBlockByHash
* eth_getBlockByNumber
* eth_getTransactionByHash
* eth_getTransactionByBlockHashAndIndex
* eth_getTransactionByBlockNumberAndIndex
* eth_getTransactionReceipt
* eth_getUncleByBlockHashAndIndex
* eth_getUncleByBlockNumberAndIndex
* eth_getCompilers
* eth_compileLLL
* eth_compileSolidity
* eth_compileSerpent
* eth_newFilter
* eth_newBlockFilter
* eth_newPendingTransactionFilter
* eth_uninstallFilter
* eth_getFilterChanges
* eth_getFilterLogs
* eth_getLogs
* eth_getWork
* eth_submitWork
* eth_submitHashrate
* db_putString
* db_getString
* db_putHex
* db_getHex
* shh_post
* shh_version
* shh_newIdentity
* shh_hasIdentity
* shh_newGroup
* shh_addToGroup
* shh_newFilter
* shh_uninstallFilter
* shh_getFilterChanges
* shh_getMessages

### Examples

```elixir
iex> Ethereumex.HttpClient.web3_client_version
{:ok,
 %{"id" => 0, "jsonrpc" => "2.0",
   "result" => "Geth/v1.6.5-stable-cf87713d/darwin-amd64/go1.8.3"}}

iex> Ethereumex.HttpClient.web3_sha3(["wrong_param"])
{:error,
 %{"code" => -32602,
   "message" => "invalid argument 0: missing 0x prefix for hex data"}}

iex> Ethereumex.HttpClient.eth_get_balance(["0x407d73d8a49eeb85d32cf465507dd71d507100c1", "latest"])
{:ok, %{"id" => 2, "jsonrpc" => "2.0", "result" => "0x0"}}
```
Note that all method names are snakecases, so, for example, shh_getMessages method has corresponding Ethereumex.HttpClient.shh_get_messages/1 method

### Custom requests
Many Ethereum protocol implementations support additional JSON-RPC API methods. To use them, you should call Ethereumex.HttpClient.send_request/2 method.

For example, let's call geth's rpc_modules method.

```elixir
iex> Ethereumex.HttpClient.send_request("rpc_modules")
{:ok,
 %{"id" => 5, "jsonrpc" => "2.0",
   "result" => %{"eth" => "1.0", "net" => "1.0", "rpc" => "1.0",
     "web3" => "1.0"}}}
```

## Contributing

1. [Fork it!](http://github.com/ayrat555/ethereumex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Ayrat Badykov (@ayrat555)

## License

Ethereumex is released under the MIT License.
