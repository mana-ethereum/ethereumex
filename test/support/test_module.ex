defmodule Ethereumex.TestModule do
  use Ethereumex.Client

  def request(%{"method" => method_name, "id" => id}) do
    {id, method_name}
  end
end
