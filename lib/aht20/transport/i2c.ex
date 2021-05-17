defmodule AHT20.Transport.I2C do
  @moduledoc false

  @behaviour AHT20.Transport

  @doc """
  Open an I2C bus.
  """
  def open(bus_name) do
    apply(
      transport_module(),
      :open,
      [bus_name]
    )
  end

  @doc """
  Write `data` to the I2C device at `bus_address`.
  """
  def write(reference, bus_address, data) do
    apply(
      transport_module(),
      :write,
      [reference, bus_address, data]
    )
  end

  @doc """
  Initiate a read transaction to the I2C device at the specified `bus_address`.
  """
  def read(reference, bus_address, bytes_to_read) do
    apply(
      transport_module(),
      :read,
      [reference, bus_address, bytes_to_read]
    )
  end

  @doc """
  Write `data` to an I2C device and then immediately issue a read.
  """
  def write_read(reference, bus_address, data, bytes_to_read) do
    apply(
      transport_module(),
      :write_read,
      [reference, bus_address, data, bytes_to_read]
    )
  end

  defp transport_module() do
    Application.get_env(:aht20, :transport_module, Circuits.I2C)
  end
end
