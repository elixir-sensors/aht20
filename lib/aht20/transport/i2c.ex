defmodule AHT20.Transport.I2C do
  @moduledoc false

  @behaviour AHT20.Transport

  def start_link(bus_name) do
    apply(
      transport_module(),
      :start_link,
      [bus_name]
    )
  end

  def read(transport, bytes_to_read) do
    apply(
      transport_module(),
      :read,
      [transport, bytes_to_read]
    )
  end

  def write(transport, register_and_data) do
    apply(
      transport_module(),
      :write,
      [transport, register_and_data]
    )
  end

  def write(transport, register, data) do
    apply(
      transport_module(),
      :write,
      [transport, register, data]
    )
  end

  def write_read(transport, register, bytes_to_read) do
    apply(
      transport_module(),
      :write_read,
      [transport, register, bytes_to_read]
    )
  end

  defp transport_module() do
    Application.get_env(:aht20, :transport_module, I2cServer)
  end
end
