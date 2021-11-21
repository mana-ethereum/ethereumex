# Ethereumex

[![CircleCI](https://circleci.com/gh/mana-ethereum/ethereumex.svg?style=svg)](https://circleci.com/gh/exthereum/ethereumex)
[![Module Version](https://img.shields.io/hexpm/v/ethereumex.svg)](https://hex.pm/packages/ethereumex)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ethereumex/)
[![Total Download](https://img.shields.io/hexpm/dt/ethereumex.svg)](https://hex.pm/packages/ethereumex)
[![License](https://img.shields.io/hexpm/l/ethereumex.svg)](https://github.com/mana-ethereum/ethereumex/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/mana-ethereum/ethereumex.svg)](https://github.com/mana-ethereum/ethereumex/commits/master)

<!-- MDOC !-->

Elixir JSON-RPC client for the Ethereum blockchain.

Check out the documentation [here](https://hexdocs.pm/ethereumex/Ethereumex.html#content).

## Installation

Add `:ethereumex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ethereumex, "~> 0.7.1"}
  ]
end
```

Ensure `:ethereumex` is started before your application:

```elixir
def application do
  [
    applications: [:ethereumex]
  ]
end
```

## Configuration

In `config/config.exs`, add Ethereum protocol host params to your config file

```elixir
config :ethereumex,
  url: "http://localhost:8545"
```

You can also configure the `HTTP` request timeout for requests sent to the Ethereum JSON-RPC
(you can also overwrite this configuration in `opts` used when calling the client).

```elixir
config :ethereumex,
  http_options: [pool_timeout: 5000, receive_timeout: 15_000]
```

`:timeout` - timeout to establish a connection, in milliseconds. Default is 8000
`:recv_timeout` - timeout used when receiving a connection. Default is 5000

If you want to use IPC you will need to set a few things in your config.

First, specify the `:client_type`:

```elixir
config :ethereumex,
  client_type: :ipc
```

This will resolve to `:http` by default.

Second, specify the `:ipc_path`:

```elixir
config :ethereumex,
  ipc_path: "/path/to/ipc"
```

If you want to count the number of RPC calls per RPC method or overall,
you can attach yourself to executed telemetry events.
There are two events you can attach yourself to:
`[:ethereumex]` # has RPC method name in metadata
Emitted event: `{:event, [:ethereumex], %{counter: 1}, %{method_name: "method_name"}}`

or more granular
`[:ethereumex, <rpc_method>]` # %{} metadata
Emitted event: `{:event, [:ethereumex, :method_name_as_atom], %{counter: 1}, %{}}`

Each event caries a single ticker that you can pass into your counters (like `Statix.increment/2`).
Be sure to add :telemetry as project dependency.


The IPC client type mode opens a pool of connection workers (default is 5 and 2, respectively). You can configure the pool size.

```elixir
config :ethereumex,
  ipc_worker_size: 5,
  ipc_max_worker_overflow: 2,
  ipc_request_timeout: 60_000
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
* eth_getProof
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

### IpcClient

You can follow along with any of these examples using IPC by replacing `HttpClient` with `IpcClient`.

### Examples

```elixir
iex> Ethereumex.HttpClient.web3_client_version
{:ok, "Parity//v1.7.2-beta-9f47909-20170918/x86_64-macos/rustc1.19.0"}

# Using the url option will overwrite the configuration
iex> Ethereumex.HttpClient.web3_client_version(url: "http://localhost:8545")
{:ok, "Parity//v1.7.2-beta-9f47909-20170918/x86_64-macos/rustc1.19.0"}

iex> Ethereumex.HttpClient.web3_sha3("wrong_param")
{:error, %{"code" => -32602, "message" => "Invalid params: invalid format."}}

iex> Ethereumex.HttpClient.eth_get_balance("0x407d73d8a49eeb85d32cf465507dd71d507100c1")
{:ok, "0x0"}
```
Note that all method names are snakecases, so, for example, shh_getMessages method has corresponding Ethereumex.HttpClient.shh_get_messages/1 method. Signatures can be found in Ethereumex.Client.Behaviour. There are more examples in tests.

#### eth_call example - Read only smart contract calls
In order to call a smart contract using the JSON-RPC interface you need to properly hash the data attribute (this will need to include the contract method signature along with arguments if any). You can do this manually or use a hex package like [ABI](https://hex.pm/packages/ex_abi) to parse your smart contract interface or encode individual calls.

```elixir
defp deps do
  [
    ...
    {:ethereumex, "~> 0.7.1"},
    {:ex_abi, "~> 0.5.5"}
    ...
  ]
end
```

Now load the ABI and pass the method signature. Note that the address needs to be converted to bytes:

```elixir
address           = "0x123" |> String.slice(2..-1) |> Base.decode16(case: :mixed)
contract_address  = "0x432"
abi_encoded_data  = ABI.encode("balanceOf(address)", [address]) |> Base.encode16(case: :lower)
```

Now you can use eth_call to execute this smart contract command:

```elixir
balance_bytes = Ethereumex.HttpClient.eth_call(%{
  data: "0x" <> abi_encoded_data,
  to: contract_address
})
```

To convert the balance into an integer:

```elixir
balance_bytes
|> String.slice(2..-1)
|> Base.decode16!(case: :lower)
|> TypeDecoder.decode_raw([{:uint, 256}])
|> List.first
```

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

To send batch requests use Ethereumex.HttpClient.batch_request/1 or Ethereumex.HttpClient.batch_request/2 method.

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

<!-- MDOC !-->

## Built on Ethereumex

If you are curious what others are building with ethereumex, you might want to take a look at these projects:

- [exw3](https://github.com/hswick/exw3) - A high-level contract abstraction and other goodies similar to web3.js

- [eth](https://github.com/izelnakri/eth) - Ethereum utilities for Elixir.

- [eth_contract](https://github.com/agilealpha/eth_contract) - A set of helper methods for calling ETH Smart Contracts via JSON RPC.

## Contributing

1. [Fork it!](http://github.com/ayrat555/ethereumex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and License

Copyright (c) 2018 Ayrat Badykov

Released under the MIT License, which can be found in the repository in
[LICENSE.md](./LICENSE.md).
