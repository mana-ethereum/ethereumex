# Ethereumex [![CircleCI](https://circleci.com/gh/exthereum/ethereumex.svg?style=svg)](https://circleci.com/gh/exthereum/ethereumex)

Elixir JSON-RPC client for the Ethereum blockchain

This is WIP code meant to complete integration testing and UNIX domain socket development

I've implemented [exVCR](https://github.com/parroty/exvcr) to record tests that return positive
```
mix vcr.delete test_name
```
The command above is an example of removing the cassette to reset the test to use actual HTTP.
"Cassette" names are test_name.json found in ./fixture/vcr_cassettes .

TODO:  
- [ ] geth truffle box for testing consistency
- [ ] method by method latest review of EEthereum API for JSONRPC
- [ ] IPC Methods allowed
- [ ] integrate abi library for encoding data to test eth_call
- [ ] whisper methods
- [ ] expand configuration docs
- [ ] add on/off configuration option for exVCR

## Installation
Add Ethereumex to your `mix.exs` dependencies:

1. Add `ethereumex` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [{:ethereumex, "~> 0.3.2"}]
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

- [x]web3_clientVersion
- [x]web3_sha3
- [x]net_version
- [x]net_peerCount
- [x]net_listening
- [x]eth_protocolVersion
- [x]eth_syncing
- [x]eth_coinbase
- [x]eth_mining
- [x]eth_hashrate
- [x]eth_gasPrice
- [x]eth_accounts
- [x]eth_blockNumber
- [x]eth_getBalance
- [x]eth_getStorageAt
- [x]eth_getTransactionCount
- [x]eth_getBlockTransactionCountByHash
- [x]eth_getBlockTransactionCountByNumber
- [x]eth_getUncleCountByBlockHash
- [x]eth_getUncleCountByBlockNumber
- [x]eth_getCode
- [ ]eth_sign WIP
- [x]eth_sendTransaction
- [x]eth_sendRawTransaction
- [ ]eth_call WIP
- [ ]eth_estimateGas WIP
- [x]eth_getBlockByHash
- [x]eth_getBlockByNumber
- [x]eth_getTransactionByHash
- [x]eth_getTransactionByBlockHashAndIndex
- [x]eth_getTransactionByBlockNumberAndIndex
- [ ]eth_getTransactionReceipt
- [ ]eth_getUncleByBlockHashAndIndex
- [ ]eth_getUncleByBlockNumberAndIndex
- [ ]eth_getCompilers [deprecated](https://github.com/ethereum/go-ethereum/issues/3793)
- [ ]eth_compileLLL [deprecated](https://github.com/ethereum/go-ethereum/issues/3793)
- [ ]eth_compileSolidity [deprecated](https://github.com/ethereum/go-ethereum/issues/3793)
- [ ]eth_compileSerpent [deprecated](https://github.com/ethereum/go-ethereum/issues/3793)
- [ ]eth_newFilter
- [ ]eth_newBlockFilter
- [ ]eth_newPendingTransactionFilter
- [ ]eth_uninstallFilter
- [ ]eth_getFilterChanges
- [ ]eth_getFilterLogs
- [ ]eth_getLogs
- [ ]eth_getWork
- [ ]eth_submitWork
- [ ]eth_submitHashrate
- [ ]db_putString [deprecated](https://github.com/ethereum/go-ethereum/issues/311)
- [ ]db_getString [deprecated](https://github.com/ethereum/go-ethereum/issues/311)
- [ ]db_putHex [deprecated](https://github.com/ethereum/go-ethereum/issues/311)
- [ ]db_getHex [deprecated](https://github.com/ethereum/go-ethereum/issues/311)
- [ ]shh_post
- [ ]shh_version
- [ ]shh_newIdentity
- [ ]shh_hasIdentity
- [ ]shh_newGroup
- [ ]shh_addToGroup
- [ ]shh_newFilter
- [ ]shh_uninstallFilter
- [ ]shh_getFilterChanges
- [ ]shh_getMessages

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


#### eth_call example - Read only smart contract calls
In order to call a smart contract using the JSON-RPC interface you need to properly hash the data attribute (this will need to include the contract method signature along with arguments if any). You can do this manually or use a hex package like (ABI)[https://github.com/exthereum/abi] to parse your smart contract interface or encode individual calls.

```elixir
defp deps do
  [
    ...
    {:ethereumex, "~> 0.3.2"},
    {:abi, "~> 0.1.8"}
    ...
  ]
end
```

Now load the abi and pass the method signature. Note that the address needs to be converted to bytes

```elixir
address           = "0x123" |> String.slice(2..-1) |> Base.decode16(case: :mixed)
contract_address  = "0x432"  
abi_encoded_data  = ABI.encode("balanceOf(address)", [address])
```

Now you can use eth_call to execute this smart contract command:

```elixir
balance_bytes = Ethereumex.HttpClient.eth_call(%{
  data: "0x" <> abi_encoded_data,
  contract: contract_address
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

#### eth_send_raw_transaction example - Payable smart contract call
Calling a smart contract method that requires computation will cost you gas or ether (if that method requires payment also). This means you will have to sign your transactions using the private key that owns some ethereum. In order to send signed transactions you will need both (ABI)[https://hex.pm/packages/abi] and (Blockchain)[https://hex.pm/packages/blockchain] hex packages.

```elixir
abi_encoded_data = ABI.encode("transferFrom(address,address,uint)", [from_address, to_address, token_id])
contract_address = "0x123"

transaction_data = %Blockchain.Transaction{
    data: abi_encoded_data,
    gas_limit: 100_000,
    gas_price: 16_000_000_000,
    init: <<>>,
    nonce: 5,
    to: contract_address,
    value: 0
}
|> Blockchain.Transaction.Signature.sign_transaction(private_key)
|> Blockchain.Transaction.serialize()
|> ExRLP.encode()
|> Base.encode16(case: :lower)

Ethereumex.HttpClient.eth_send_raw_transaction("0x" <> transaction_data)
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
