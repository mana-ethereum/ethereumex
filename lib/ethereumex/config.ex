defmodule Ethereumex.Config do
  @moduledoc false

  @spec rpc_url() :: binary()
  def rpc_url do
    "#{scheme()}://#{host()}:#{port()}"
  end

  @spec scheme() :: binary()
  defp scheme do
    env_var!(:scheme)
  end

  @spec host() :: binary()
  defp host do
    env_var!(:host)
  end

  @spec port() :: integer()
  defp port do
    env_var!(:port)
  end

  @spec env_var!(atom()) :: binary() | integer()
  defp env_var!(var) do
    value = Application.fetch_env!(:ethereumex, var)

    if is_nil(value), do: raise ArgumentError, message: "#{var} is not provided!"

    value
  end
end
