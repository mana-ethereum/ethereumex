defmodule Ethereumex.Client.MacroTest do
  use ExUnit.Case

  import Ethereumex.Client.Methods

  defmodule TestModule do
    use Ethereumex.Client.Macro

    def request(%{"method" => method_name, "id" => id}) do
      {id, method_name}
    end
  end

  setup_all do
    TestModule.start_link

    :ok
  end

  test "generates json-rpc api methods" do
    methods = available_methods()

    methods
    |> Enum.reduce(0, fn({original_name, formatted_name}, id_number) ->
      {^id_number, ^original_name} = apply(TestModule, formatted_name, [])

      id_number + 1
    end)
  end
end
