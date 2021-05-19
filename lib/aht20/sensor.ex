defmodule AHT20.Sensor do
  @moduledoc false

  use Bitwise, only_operators: true

  @default_bus_name "i2c-1"
  @default_bus_address 0x38

  @aht20_cmd_initialize 0xBE
  @aht20_cmd_trigger_measurement 0xAC
  @aht20_cmd_soft_reset 0xBA

  @type bus_name :: AHT20.Transport.bus_name()
  @type bus_address :: AHT20.Transport.bus_address()

  @type config :: [{:bus_name, bus_name} | {:bus_address, bus_address}]

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
         :ok <- AHT20.Transport.I2C.write(transport, [@aht20_cmd_soft_reset]),
         :ok <- Process.sleep(20),
         :ok <- AHT20.Transport.I2C.write(transport, [@aht20_cmd_initialize, <<0x08, 0x00>>]) do
      {:ok, __struct__(transport: transport, bus_address: bus_address)}
    else
      _error -> {:error, :device_not_found}
    end
  end

  @spec measure(t) :: {:ok, <<_::56>>} | {:error, any}
  def measure(%{transport: transport}) do
    with :ok <- AHT20.Transport.I2C.write(transport, [@aht20_cmd_trigger_measurement, <<0x33, 0x00>>]),
         :ok <- Process.sleep(75),
         {:ok, sensor_output} <- AHT20.Transport.I2C.read(transport, 7) do
      {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
    end
  end
end
