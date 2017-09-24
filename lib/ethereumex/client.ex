defmodule Ethereumex.Client do
  @callback request(map()) :: any()
  @moduledoc false

  alias Ethereumex.Client.Utils

  defmacro __using__(_) do
    methods = Utils.available_methods

    quote location: :keep, bind_quoted: [methods: methods] do
      @behaviour Ethereumex.Client
      use GenServer

      def start_link(id \\ 0) when is_number(id) do
        GenServer.start_link(__MODULE__, id, name: __MODULE__)
      end

      def reset_id do
        GenServer.cast __MODULE__, :reset_id
      end

      def handle_call({:request, params}, _from, id) do
        params  = params |> Map.put("id", id)

        response = request(params)

        {:reply, response, id + 1}
      end

      def handle_cast(:reset_id, _id) do
        {:noreply, 0}
      end

      methods
      |> Enum.each(fn({original_name, formatted_name}) ->
        def unquote(formatted_name)(params \\ []) when is_list(params) do
          send_request(unquote(original_name), params)
        end
      end)

      @spec send_request(binary(), [binary()] | [map()]) :: any()
      def send_request(method_name, params \\ []) when is_list(params) do
        params = params |> add_method_info(method_name)

        GenServer.call __MODULE__, {:request, params}
      end

      @spec request(map()) :: any()
      def request(_payload) do
      end

      @spec add_method_info([binary()] | [map()], binary()) :: map()
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
