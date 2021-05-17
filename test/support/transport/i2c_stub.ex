defmodule AHT20.Transport.I2C.Stub do
  @moduledoc false

  @behaviour AHT20.Transport

  def open(_bus_name) do
    {:ok, Kernel.make_ref()}
  end

  def write(_reference, _bus_address, _data) do
    :ok
  end

  def read(_reference, _bus_address, _bytes_to_read) do
    {:ok, "stub"}
  end

  def write_read(_reference, _bus_address, _data, _bytes_to_read) do
    {:ok, "stub"}
  end
end
