defmodule Ethereumex.Client.Utils do
  @moduledoc false

  @spec available_methods() :: [{binary(), atom()}]
  def available_methods do
    read_methods() |> Enum.map(&format_name/1)
  end

  @spec format_name(binary()) :: {binary(), atom()}
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

  @spec read_methods() :: [binary()]
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
