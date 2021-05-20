defmodule AHT20.Sensor do
  @moduledoc """
  Represents the AHT20 sensor.
  """

  @default_bus_name "i2c-1"
  @default_bus_address 0x38

  @type bus_name :: AHT20.Transport.bus_name()
  @type bus_address :: AHT20.Transport.bus_address()

  @type config :: [{:bus_name, bus_name} | {:bus_address, bus_address}]

  @typedoc """
  The options that are required for the sensor initialization.
  * `:bus_name` - which I2C bus to use (defaults to `"i2c-1"`)
  * `:bus_address` - the address of the AHT20 (defaults to 0x38)
  """
  @type t :: %__MODULE__{
          bus_address: bus_address,
          transport: pid
        }

  defstruct [:transport, :bus_address]

  @spec init(config) :: {:ok, t} | {:error, any}
  def init(config \\ []) do
    bus_name = config[:bus_name] || @default_bus_name
    bus_address = config[:bus_address] || @default_bus_address

    with {:ok, transport} <- AHT20.Transport.I2C.start_link(bus_name: bus_name, bus_address: bus_address),
         :ok <- Process.sleep(40),
         :ok <- AHT20.Comm.reset(transport),
         :ok <- Process.sleep(10),
         :ok <- AHT20.Comm.init(transport) do
      {:ok, __struct__(transport: transport, bus_address: bus_address)}
    else
      _error -> {:error, :device_not_found}
    end
  end

  @spec measure(t) :: {:ok, <<_::56>>} | {:error, any}
  def measure(%{transport: transport}) do
    with {:ok, sensor_output} <- AHT20.Comm.measure(transport) do
      {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
    end
  end
end
