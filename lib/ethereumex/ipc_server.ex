defmodule Ethereumex.IpcServer do
  use GenServer
  @moduledoc false

  def init(state) do
    opts = [:binary, active: false]
    response = :gen_tcp.connect({:local, state[:path]}, 0, opts)

    case response do
      {:ok, socket} -> {:ok, %{state | socket: socket}}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, Map.merge(state, %{socket: nil}), name: IpcServer)
  end

  def post(request) do
    GenServer.call(IpcServer, {:request, request})
  end

  def request_helper({:error, reason}, _socket) do
    {:error, reason}
  end

  def request_helper(:ok, socket) do
    :gen_tcp.recv(socket, 0)
  end

  def request_helper(data, _socket) do
    {:error, data}
  end

  def handle_call({:request, request}, _from, %{socket: socket} = state) do
    response = request_helper(:gen_tcp.send(socket, request), socket)
    {:reply, response, state}
  end
end
