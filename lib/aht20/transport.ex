defmodule AHT20.Transport do
  @moduledoc """
  Defines a behaviour required for I2C device. Based on [Circuits I2C's API](https://github.com/elixir-circuits/circuits_i2c/blob/main/lib/i2c.ex).
  """

  @type bus_name :: String.t()
  @type bus_address :: 0..127
  @type data :: binary
  @type opts :: [{:retries, non_neg_integer}]

  @callback open(bus_name) :: {:ok, reference} | {:error, any}
  @callback write(reference, bus_address, data) :: :ok | {:error, any}
  @callback read(reference, bus_address, integer) :: {:ok, binary} | {:error, any}
  @callback write_read(reference, bus_address, data, integer) :: {:ok, binary} | {:error, any}
end

defmodule AHT20.I2CDevice do
  @moduledoc """
  Lets you communicate with hardware devices using the [I2C](https://en.wikipedia.org/wiki/I%C2%B2C) protocol.
  A thin wrapper of [elixir-circuits/circuits_i2c](https://github.com/elixir-circuits/circuits_i2c).
  """

  @behaviour AHT20.Transport

  @doc """
  Open an I2C bus.
  """
  def open(bus_name), do: transport_module().open(bus_name)

  @doc """
  Write `data` to the I2C device at `bus_address`.
  """
  def write(reference, bus_address, data) do
    transport_module().write(reference, bus_address, data)
  end

  @doc """
  Initiate a read transaction to the I2C device at the specified `bus_address`.
  """
  def read(reference, bus_address, bytes_to_read) do
    transport_module().read(reference, bus_address, bytes_to_read)
  end

  @doc """
  Write `data` to an I2C device and then immediately issue a read.
  """
  def write_read(reference, bus_address, data, bytes_to_read) do
    transport_module().write_read(reference, bus_address, data, bytes_to_read)
  end

  # This enables us to switch the implementation with a mock.
  defp transport_module() do
    # https://hexdocs.pm/elixir/master/library-guidelines.html#avoid-compile-time-application-configuration
    Application.get_env(:aht20, :transport_module, Circuits.I2C)
  end
end

defmodule AHT20.I2CDevice.Stub do
  @moduledoc false

  @behaviour AHT20.Transport

  def open(_bus_name), do: {:ok, Kernel.make_ref()}

  def write(_reference, _bus_address, _data), do: :ok

  def read(_reference, _bus_address, _bytes_to_read), do: {:ok, "stub"}

  def write_read(_reference, _bus_address, _data, _bytes_to_read), do: {:ok, "stub"}
end
