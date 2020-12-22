defmodule Ethereumex.Config do
  @moduledoc false
  alias Ethereumex.IpcServer

  def setup_children(type \\ client_type()) do
    case type do
      :ipc ->
        [
          :poolboy.child_spec(:worker, poolboy_config(),
            path: Enum.join([System.user_home!(), ipc_path()]),
            ipc_request_timeout: ipc_request_timeout()
          )
        ]

      :http ->
        []

      opt ->
        raise "Invalid :client option (#{opt}) in config"
    end
  end

  @spec rpc_url() :: binary
  def rpc_url do
    case Application.get_env(:ethereumex, :url) do
      url when is_binary(url) and url != "" ->
        url

      els ->
        raise ArgumentError,
          message:
            "Please set config variable `config :ethereumex, :url, \"http://...\", got: `#{
              inspect(els)
            }`"
    end
  end

  @spec ipc_path() :: binary
  def ipc_path do
    case Application.get_env(:ethereumex, :ipc_path, "") do
      path when is_binary(path) and path != "" ->
        path

      not_a_path ->
        raise ArgumentError,
          message:
            "Please set config variable `config :ethereumex, :ipc_path, \"path/to/ipc\", got `#{
              not_a_path
            }`. Note: System.user_home! will be prepended to path for you on initialization"
    end
  end

  @spec http_options() :: keyword
  def http_options do
    Application.get_env(:ethereumex, :http_options, [])
  end

  @spec client_type() :: atom
  def client_type do
    Application.get_env(:ethereumex, :client_type, :http)
  end

  @spec poolboy_config() :: keyword
  defp poolboy_config do
    [
      {:name, {:local, :ipc_worker}},
      {:worker_module, IpcServer},
      {:size, ipc_worker_size()},
      {:max_overflow, ipc_max_worker_overflow()}
    ]
  end

  @spec ipc_worker_size() :: integer
  defp ipc_worker_size do
    Application.get_env(:ethereumex, :ipc_worker_size, 5)
  end

  @spec ipc_max_worker_overflow() :: integer
  defp ipc_max_worker_overflow do
    Application.get_env(:ethereumex, :ipc_max_worker_overflow, 2)
  end

  @spec ipc_request_timeout() :: integer
  defp ipc_request_timeout do
    Application.get_env(:ethereumex, :ipc_request_timeout, 60_000)
  end
end
