defmodule Ethereumex.Client do
  @callback request(payload :: map) :: tuple
  @callback batch_request(payload :: list) :: tuple
end
