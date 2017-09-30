defmodule Ethereumex.Client.Macro do
  @callback request(map) :: {:ok, any} | {:error, any}
  @moduledoc false

  alias Ethereumex.Client.Methods

  defmacro __using__(_) do
    methods = Methods.available_methods

    quote location: :keep, bind_quoted: [methods: methods] do
      @behaviour Ethereumex.Client.Macro
      alias Ethereumex.Client.Server

      def start_link do
        Server.start_link(__MODULE__)
      end

      def reset_id do
        GenServer.cast __MODULE__, :reset_id
      end

      methods
      |> Enum.each(fn({original_name, formatted_name}) ->
        def unquote(formatted_name)(params \\ []) when is_list(params) do
          send_request(unquote(original_name), params)
        end
      end)

      @spec send_request(binary, [binary] | [map]) :: any
      def send_request(method_name, params \\ []) when is_list(params) do
        params = params |> add_method_info(method_name)

        server_request(params)
      end

      @spec request(map) :: {:ok, any} | {:error, any}
      def request(params) do
        {:error, :not_implemented}
      end

      @spec server_request(map) :: {:ok, any} | {:error, any}
      defp server_request(params) do
        GenServer.call __MODULE__, {:request, params}
      end

      @spec add_method_info([binary] | [map], binary) :: map
      defp add_method_info(params, method_name) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
      end

      defoverridable [request: 1]
    end
  end
end
