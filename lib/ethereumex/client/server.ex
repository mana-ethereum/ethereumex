defmodule Ethereumex.Client.Server do
  use GenServer

  @moduledoc false

  def start_link(module) when is_atom(module) do
    GenServer.start_link(__MODULE__, {module, 0}, name: module)
  end

  def handle_call({:request, params}, _from, {module, id}) when is_list(params) do
    params =
      params
      |> Enum.with_index
      |> Enum.map(fn({req_data, index}) ->
        Map.put(req_data, "id", index + id)
      end)

    response = apply(module, :single_request, [params])

    {:reply, response, {module, id + Enum.count(params)}}
  end

  def handle_call({:request, params}, _from, {module, id}) do
    params = Map.put(params, "id", id)

    response = apply(module, :single_request, [params])

    {:reply, response, {module, id + 1}}
  end

  def handle_cast(:reset_id, {module, _id}) do
    {:noreply, {module, 0}}
  end
end
