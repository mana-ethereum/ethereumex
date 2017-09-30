defmodule Ethereumex.Client.Methods do
  @moduledoc false

  @spec methods_with_params() :: [{binary, atom}]
  def methods_with_params do
    all_methods()
    |> Enum.filter(fn(%{"params" => value}) ->
      value == true
    end)
    |> Enum.map(fn(%{"name" => name}) ->
      name |> format_name
    end)
  end

  @spec methods_without_params() :: [{binary, atom}]
  def methods_without_params do
    all_methods()
    |> Enum.filter(fn(%{"params" => value}) ->
      value == false
    end)
    |> Enum.map(fn(%{"name" => name}) ->
      name |> format_name
    end)
  end

  @spec all_methods() :: map
  defp all_methods do
    {:ok, raw_methods} =
      File.cwd!
      |> List.wrap
      |> Kernel.++(["lib", "ethereumex", "client", "methods.json"])
      |> Path.join
      |> File.read
    %{"methods" => methods} = raw_methods |> Poison.decode!

    methods
  end

  @spec format_name(binary) :: {binary, atom}
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
end
