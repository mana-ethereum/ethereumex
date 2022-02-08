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
    {:ethereumex, "~> 0.9"}
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
  http_options: [pool_timeout: 5000, receive_timeout: 15_000],
  http_headers: [{"Content-Type", "application/json"}]
```

`:pool_timeout` - This timeout is applied when we check out a connection from the pool. Default value is `5_000`.
`:receive_timeout` - The maximum time to wait for a response before returning an error. Default value is `15_000`

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

## Test

Download `parity` and initialize the password file

```
$ make setup
```

Run `parity`

```
$ make run
```

Run tests

```
$ make test
```

## Usage

### Available methods:

* [`web3_clientVersion`](https://eth.wiki/json-rpc/API#web3_clientversion)
* [`web3_sha3`](https://eth.wiki/json-rpc/API#web3_sha3)
* [`net_version`](https://eth.wiki/json-rpc/API#net_version)
* [`net_peerCount`](https://eth.wiki/json-rpc/API#net_peercount)
* [`net_listening`](https://eth.wiki/json-rpc/API#net_listening)
* [`eth_protocolVersion`](https://eth.wiki/json-rpc/API#eth_protocolversion)
* [`eth_syncing`](https://eth.wiki/json-rpc/API#eth_syncing)
* [`eth_coinbase`](https://eth.wiki/json-rpc/API#eth_coinbase)
* [`eth_mining`](https://eth.wiki/json-rpc/API#eth_mining)
* [`eth_hashrate`](https://eth.wiki/json-rpc/API#eth_hashrate)
* [`eth_gasPrice`](https://eth.wiki/json-rpc/API#eth_gasprice)
* [`eth_accounts`](https://eth.wiki/json-rpc/API#eth_accounts)
* [`eth_blockNumber`](https://eth.wiki/json-rpc/API#eth_blocknumber)
* [`eth_getBalance`](https://eth.wiki/json-rpc/API#eth_getbalance)
* [`eth_getStorageAt`](https://eth.wiki/json-rpc/API#eth_getstorageat)
* [`eth_getTransactionCount`](https://eth.wiki/json-rpc/API#eth_gettransactioncount)
* [`eth_getBlockTransactionCountByHash`](https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbyhash)
* [`eth_getBlockTransactionCountByNumber`](https://eth.wiki/json-rpc/API#eth_getblocktransactioncountbynumber)
* [`eth_getUncleCountByBlockHash`](https://eth.wiki/json-rpc/API#eth_getunclecountbyblockhash)
* [`eth_getUncleCountByBlockNumber`](https://eth.wiki/json-rpc/API#eth_getunclecountbyblocknumber)
* [`eth_getCode`](https://eth.wiki/json-rpc/API#eth_getcode)
* [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
* [`eth_sendTransaction`](https://eth.wiki/json-rpc/API#eth_sendtransaction)
* [`eth_sendRawTransaction`](https://eth.wiki/json-rpc/API#eth_sendrawtransaction)
* [`eth_call`](https://eth.wiki/json-rpc/API#eth_call)
* [`eth_estimateGas`](https://eth.wiki/json-rpc/API#eth_estimategas)
* [`eth_getBlockByHash`](https://eth.wiki/json-rpc/API#eth_getblockbyhash)
* [`eth_getBlockByNumber`](https://eth.wiki/json-rpc/API#eth_getblockbynumber)
* [`eth_getTransactionByHash`](https://eth.wiki/json-rpc/API#eth_gettransactionbyhash)
* [`eth_getTransactionByBlockHashAndIndex`](https://eth.wiki/json-rpc/API#eth_gettransactionbyblockhashandindex)
* [`eth_getTransactionByBlockNumberAndIndex`](https://eth.wiki/json-rpc/API#eth_gettransactionbyblocknumberandindex)
* [`eth_getTransactionReceipt`](https://eth.wiki/json-rpc/API#eth_gettransactionreceipt)
* [`eth_getUncleByBlockHashAndIndex`](https://eth.wiki/json-rpc/API#eth_getunclebyblockhashandindex)
* [`eth_getUncleByBlockNumberAndIndex`](https://eth.wiki/json-rpc/API#eth_getunclebyblocknumberandindex)
* [`eth_getCompilers`](https://eth.wiki/json-rpc/API#eth_getcompilers)
* [`eth_compileLLL`](https://eth.wiki/json-rpc/API#eth_compilelll)
* [`eth_compileSolidity`](https://eth.wiki/json-rpc/API#eth_compilesolidity)
* [`eth_compileSerpent`](https://eth.wiki/json-rpc/API#eth_compileserpent)
* [`eth_newFilter`](https://eth.wiki/json-rpc/API#eth_newfilter)
* [`eth_newBlockFilter`](https://eth.wiki/json-rpc/API#eth_newblockfilter)
* [`eth_newPendingTransactionFilter`](https://eth.wiki/json-rpc/API#eth_newpendingtransactionfilter)
* [`eth_uninstallFilter`](https://eth.wiki/json-rpc/API#eth_uninstallfilter)
* [`eth_getFilterChanges`](https://eth.wiki/json-rpc/API#eth_getfilterchanges)
* [`eth_getFilterLogs`](https://eth.wiki/json-rpc/API#eth_getfilterlogs)
* [`eth_getLogs`](https://eth.wiki/json-rpc/API#eth_getlogs)
* eth_getProof
* [`eth_getWork`](https://eth.wiki/json-rpc/API#eth_getwork)
* [`eth_submitWork`](https://eth.wiki/json-rpc/API#eth_submitwork)
* [`eth_submitHashrate`](https://eth.wiki/json-rpc/API#eth_submithashrate)
* [`db_putString`](https://eth.wiki/json-rpc/API#db_putstring)
* [`db_getString`](https://eth.wiki/json-rpc/API#db_getstring)
* [`db_putHex`](https://eth.wiki/json-rpc/API#db_puthex)
* [`db_getHex`](https://eth.wiki/json-rpc/API#db_gethex)
* [`shh_post`](https://eth.wiki/json-rpc/API#shh_post)
* [`shh_version`](https://eth.wiki/json-rpc/API#shh_version)
* [`shh_newIdentity`](https://eth.wiki/json-rpc/API#shh_newidentity)
* [`shh_hasIdentity`](https://eth.wiki/json-rpc/API#shh_hasidentity)
* [`shh_newGroup`](https://eth.wiki/json-rpc/API#shh_newgroup)
* [`shh_addToGroup`](https://eth.wiki/json-rpc/API#shh_addtogroup)
* [`shh_newFilter`](https://eth.wiki/json-rpc/API#shh_newfilter)
* [`shh_uninstallFilter`](https://eth.wiki/json-rpc/API#shh_uninstallfilter)
* [`shh_getFilterChanges`](https://eth.wiki/json-rpc/API#shh_getfilterchanges)
* [`shh_getMessages`](https://eth.wiki/json-rpc/API#shh_getmessages)

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
    {:ethereumex, "~> 0.8"},
    {:ex_abi, "~> 0.5"}
    ...
  ]
end
```

Now load the ABI and pass the method signature. Note that the address needs to be converted to bytes:

```elixir
address           = "0xF742d4cE7713c54dD701AA9e92101aC42D63F895" |> String.slice(2..-1) |> Base.decode16!(case: :mixed)
contract_address  = "0xC28980830dD8b9c68a45384f5489ccdAF19D53cC"
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
     {:ok, "Parity//v1.7.2-beta-9f47909-20170918/x86_64-macos/rustc1.19.0"},
     {:ok, "42"},
     {:ok, "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"}
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
