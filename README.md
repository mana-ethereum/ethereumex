# Ethereumex [![CircleCI](https://circleci.com/gh/exthereum/ethereumex.svg?style=svg)](https://circleci.com/gh/exthereum/ethereumex)

Elixir JSON-RPC client for the Ethereum blockchain

## Installation
Add Ethereumex to your `mix.exs` dependencies:

1. Add `ethereumex` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [{:ethereumex, "~> 0.3.0"}]
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
  url: "http://localhost:8545"
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
{:ok, "Parity//v1.7.2-beta-9f47909-20170918/x86_64-macos/rustc1.19.0"}

iex> Ethereumex.HttpClient.web3_sha3("wrong_param")
{:error, %{"code" => -32602, "message" => "Invalid params: invalid format."}}

iex> Ethereumex.HttpClient.eth_get_balance("0x407d73d8a49eeb85d32cf465507dd71d507100c1")
{:ok, "0x0"}
```
Note that all method names are snakecases, so, for example, shh_getMessages method has corresponding Ethereumex.HttpClient.shh_get_messages/1 method. Signatures can be found in Ethereumex.Client.Behaviour. There are more examples in tests.

### Custom requests
Many Ethereum protocol implementations support additional JSON-RPC API methods. To use them, you should call Ethereumex.HttpClient.request/3 method.

For example, let's call parity's personal_listAccounts method.

```elixir
iex> Ethereumex.HttpClient.request("personal_listAccounts", [], [])
{:ok,
 ["0x71cf0b576a95c347078ec2339303d13024a26910",
  "0x7c12323a4fff6df1a25d38319d5692982f48ec2e"]}
```

### Batch requests
To send batch requests use Ethereumex.HttpClient.batch_request/1 method.

```elixir
requests = [
   {:web3_client_version, []},
   {:net_version, []},
   {:web3_sha3, ["0x68656c6c6f20776f726c64"]}
 ]
 Ethereumex.HttpClient.batch_request(requests)
 {
   :ok,
   [
     "Parity//v1.7.2-beta-9f47909-20170918/x86_64-macos/rustc1.19.0",
     "42",
     "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"
   ]
 }
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
