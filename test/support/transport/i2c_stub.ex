defmodule AHT20.Transport.I2C.Stub do
  @moduledoc false

  @behaviour AHT20.Transport

  def start_link(_opts) do
    {:ok, :c.pid(0, 0, 0)}
  end

  def read(_transport, _bytes_to_read) do
    {:ok, "stub"}
  end

  def write(_transport, _register_and_data) do
    :ok
  end

  def write(_transport, _register, _data) do
    :ok
  end

  def write_read(_transport, _register, _bytes_to_read) do
    {:ok, "stub"}
  end
end
