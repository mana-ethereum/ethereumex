defmodule Ethereumex.Config do
  def rpc_url do
    "#{scheme()}://#{host()}:#{port()}"
  end

  def scheme do
    env_var!(:scheme)
  end

  def host do
    env_var!(:host)
  end

  def port do
    env_var!(:port)
  end

  defp env_var!(var) do
    value = Application.fetch_env!(:ethereumex, var)

    if is_nil(value), do: raise ArgumentError, message: "#{var} is not provided!"

    value
  end
end
