defmodule Ethereumex.Client.Macro do
  alias Ethereumex.Client.Server

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Ethereumex.Client.Behaviour

      def web3_client_version(opts \\ []) do
        "web3_clientVersion" |> request([], opts)
      end

      def web3_sha3(data, opts \\ []) do
        params = [data]

        "web3_sha3" |> request(params, opts)
      end

      def net_version(opts \\ []) do
        "net_version" |> request([], opts)
      end

      def net_peer_count(opts \\ []) do
        "net_peerCount" |> request([], opts)
      end

      def net_listening(opts \\ []) do
        "net_listening" |> request([], opts)
      end

      def eth_protocol_version(opts \\ []) do
        "eth_protocolVersion" |> request([], opts)
      end

      @spec add_request_info([binary] | [map], binary) :: map
      defp add_request_info(method_name, params \\ []) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
      end

      def request(name, params, [batch: true]) do
        name |> add_request_info(params)
      end

      def request(name, params, _) do
        name
        |> add_request_info(params)
        |> server_request
      end

      def batch_request(methods) do
        methods
        |> Enum.map(fn({method, params}) ->
          opts = [batch: true]
          params = params ++ [opts]

          apply(__MODULE__, method, params)
        end)
        |> server_request
      end

      @spec server_request(map) :: {:ok, map} | {:error, map} | {:error, atom}
      defp server_request(params) do
        GenServer.call __MODULE__, {:request, params}
      end

      def start_link do
        Server.start_link(__MODULE__)
      end

      def reset_id do
        GenServer.cast __MODULE__, :reset_id
      end

      def single_request(params) do
        {:error, :not_implemented}
      end

      defoverridable [single_request: 1]
    end
  end
end
