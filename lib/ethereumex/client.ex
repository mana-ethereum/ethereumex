defmodule Ethereumex.Client do
  @callback request(payload :: map) :: tuple
  @callback batch_request(payload :: list) :: tuple

  defmacro __using__(_) do
    methods = available_methods()

    quote location: :keep, bind_quoted: [methods: methods] do
      @behaviour Ethereumex.Client

      methods
      |> Enum.each(fn({original_name, formatted_name}) ->
        def unquote(formatted_name)(params) when is_map(params) do
          params = params |> add_method_info(unquote(original_name))

          request(params)
        end

        def unquote(formatted_name)(params_list) when is_list(params_list) do
          params_list  =
            params_list
            |> Enum.map(fn(params) ->
              params |> add_method_info(unquote(original_name))
            end)

          batch_request(params_list)
        end
      end)

      def request(_) do
      end

      def batch_request(_) do
      end

      defp add_method_info(params, method_name) do
        params |> Map.put("method", method_name)
      end

      defoverridable [request: 1, batch_request: 1]
    end
  end

  defp available_methods do
    read_methods() |> Enum.map(&format_name/1)
  end

  defp format_name(original_name) do
    [scope, name_without_scope] = original_name |> String.split("_")

    name_without_scope =
      name_without_scope
      |> Macro.underscore
    formatted_name =
      "#{scope}_#{name_without_scope}"
      |> String.to_atom

    {original_name, formatted_name}
  end

  defp read_methods do
    {:ok, methods} =
      File.cwd!
      |> List.wrap
      |> Kernel.++(["lib", "ethereumex", "client", "methods"])
      |> Path.join
      |> File.read

    methods |> String.split("\n")
  end
end
