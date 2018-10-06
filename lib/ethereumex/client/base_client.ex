defmodule Ethereumex.Client.BaseClient do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      @spec single_request(map(), []) :: {:ok, any() | [any()]} | error
      def single_request(payload, opts \\ []) do
        payload
        |> encode_payload
        |> post_request(opts)
      end

      @spec encode_payload(map()) :: binary()
      defp encode_payload(payload) do
        payload |> Poison.encode!()
      end

      @spec format_batch([map()]) :: [map() | nil | binary()]
      def format_batch(list) do
        list
        |> Enum.sort(fn %{"id" => id1}, %{"id" => id2} ->
          id1 <= id2
        end)
        |> Enum.map(fn %{"result" => result} ->
          result
        end)
      end

      defp post_request(payload, opts) do
        {:error, :not_implemented}
      end

      defoverridable post_request: 2
    end
  end
end
