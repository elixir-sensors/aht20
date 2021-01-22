defmodule AHT20.I2C do
  @moduledoc false

  @type bus_name :: String.t()
  @type address :: 0..127
  @type data :: binary
  @type opts :: [{:retries, non_neg_integer}]
end

defmodule AHT20.I2C.Behaviour do
  @moduledoc """
  Defines a behaviour required for I2C device. Based on [Circuits I2C's API](https://github.com/elixir-circuits/circuits_i2c/blob/main/lib/i2c.ex).
  """
  @type bus_name :: AHT20.I2C.bus_name()
  @type address :: AHT20.I2C.address()
  @type data :: AHT20.I2C.data()
  @type opts :: AHT20.I2C.opts()

  @callback open(bus_name) :: {:ok, reference} | {:error, any}
  @callback write(reference, address, data, opts) :: :ok | {:error, any}
  @callback read(reference, address, integer, opts) :: {:ok, binary} | {:error, any}
  @callback write_read(reference, address, data, integer, opts) :: {:ok, binary} | {:error, any}
end

defmodule AHT20.I2C.Device do
  @moduledoc """
  Lets you communicate with hardware devices using the [I2C](https://en.wikipedia.org/wiki/I%C2%B2C) protocol.
  A thin wrapper of [elixir-circuits/circuits_i2c](https://github.com/elixir-circuits/circuits_i2c).
  """

  @behaviour AHT20.I2C.Behaviour

  @doc """
  Open an I2C bus.
  """
  def open(bus_name), do: i2c_module().open(bus_name)

  @doc """
  Write `data` to the I2C device at `address`.
  """
  def write(reference, address, data, opts \\ []) do
    i2c_module().write(reference, address, data, opts)
  end

  @doc """
  Initiate a read transaction to the I2C device at the specified `address`.
  """
  def read(reference, address, bytes_to_read, opts \\ []) do
    i2c_module().read(reference, address, bytes_to_read, opts)
  end

  @doc """
  Write `data` to an I2C device and then immediately issue a read.
  """
  def write_read(reference, address, data, bytes_to_read, opts \\ []) do
    i2c_module().write_read(reference, address, data, bytes_to_read, opts)
  end

  # This enables us to switch the implementation with a mock.
  defp i2c_module() do
    # https://hexdocs.pm/elixir/master/library-guidelines.html#avoid-compile-time-application-configuration
    Application.get_env(:aht20, :i2c_module, Circuits.I2C)
  end
end
