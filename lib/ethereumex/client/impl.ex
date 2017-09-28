defmodule Ethereumex.Client do
  @callback request(map()) :: any()
  @moduledoc false

  alias Ethereumex.Client.Methods

  defmacro __using__(options) do
    methods = Methods.available_methods
    module = options[:module]

    quote location: :keep, bind_quoted: [methods: methods, module: module] do
      @behaviour Ethereumex.Client
      alias Ethereumex.Client.Server

      def start_link do
        Server.start_link(module)
      end

      def reset_id do
        GenServer.cast module, :reset_id
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

      @spec server_request(map) :: any
      defp server_request(params) do
        GenSenver.call module, {:request, params}
      end

      @spec add_method_info([binary] | [map], binary) :: map
      defp add_method_info(params, method_name) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
      end
    end
  end
end
