defmodule Ethereumex.IpcServer do
  use GenServer

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

  def handle_call({:request, request}, _from, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, request)

    response = :gen_tcp.recv(socket, 0)
    {:reply, response, state}
  end
end
