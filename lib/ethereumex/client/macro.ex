defmodule Ethereumex.Client.Macro do
  alias Ethereumex.Client.Server

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Ethereumex.Client.Behaviour

      def web3_client_version do
        "web3_clientVersion"
        |> add_request_info
        |> server_request
      end

      def web3_sha3(data) do
        params = [data]

        "web3_sha3"
        |> add_request_info(params)
        |> server_request
      end

      def net_version do
        "net_version"
        |> add_request_info
        |> server_request
      end

      def net_peer_count do
        "net_peerCount"
        |> add_request_info
        |> server_request
      end

      def net_listening do
        "net_listening"
        |> add_request_info
        |> server_request
      end

      def eth_protocol_version do
        "eth_protocolVersion"
        |> add_request_info
        |> server_request
      end

      @spec add_request_info([binary] | [map], binary) :: map
      defp add_request_info(method_name, params \\ []) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
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

      def request(params) do
        {:error, :not_implemented}
      end

      defoverridable [request: 1]
    end
  end
end
