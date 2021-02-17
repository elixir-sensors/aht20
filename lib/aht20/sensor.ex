defmodule AHT20.Sensor do
  @moduledoc """
  Abstracts the basic operations of the temperature and humidity sensor AHT20.
  For the AHT20 specifications, please refer to the [AHT20 data sheet](https://cdn.sparkfun.com/assets/d/2/b/e/d/AHT20.pdf).
  """

  use Bitwise, only_operators: true

  @default_bus_name "i2c-1"
  @default_bus_address 0x38

  @aht20_cmd_initialize 0xBE
  @aht20_cmd_trigger_measurement 0xAC
  @aht20_cmd_soft_reset 0xBA
  @aht20_cmd_read_state 0x71

  @type bus_name :: AHT20.Transport.bus_name()
  @type bus_address :: AHT20.Transport.address()

  @typedoc """
  The configuration options.
  """

  @type config :: [{:bus_name, bus_name} | {:bus_address, bus_address}]

  defstruct [:ref, :bus_address]

  @typedoc """
  Represents the connection to the sensor.
  """
  @type t :: %__MODULE__{
          bus_address: bus_address,
          ref: reference
        }

  @doc """
  Connects to the sensor.
  For more info. please refer to the data sheet (section 5.4).
  """
  @spec start(config) :: {:ok, t} | {:error, any}
  def start(config \\ []) do
    with bus_name <- config[:bus_name] || @default_bus_name,
         bus_address <- config[:bus_address] || @default_bus_address,
         {:ok, ref} <- AHT20.I2CDevice.open(bus_name),
         sensor <- __struct__(ref: ref, bus_address: bus_address),
         :ok <- Process.sleep(40),
         :ok <- reset(sensor),
         :ok <- initialize(sensor) do
      {:ok, sensor}
    else
      {:error, reason} -> {:error, reason}
      unexpected -> {:error, unexpected}
    end
  end

  @doc """
  Restarts the sensor system without having to turn off and turn on the power again.
  Soft reset takes no longer than 20ms.
  For more info. please refer to the data sheet (section 5.5).
  """
  @spec reset(t) :: :ok | {:error, any}
  def reset(%{ref: ref, bus_address: bus_address}) do
    with :ok <- AHT20.I2CDevice.write(ref, bus_address, [@aht20_cmd_soft_reset]),
         :ok <- Process.sleep(20) do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  # Initialize the sensor system.
  # For more info. please refer to the data sheet (section 5.4).
  @spec initialize(t) :: :ok | :no_return
  defp initialize(%{ref: ref, bus_address: bus_address}) do
    AHT20.I2CDevice.write(ref, bus_address, [@aht20_cmd_initialize, 0x08, 0x00])
  end

  @doc """
  Triggers the sensor to read temperature and humidity.
  """
  @spec read_data(t) :: {:ok, <<_::56>>} | {:error, any}
  def read_data(%{ref: ref, bus_address: bus_address}) do
    with :ok <- AHT20.I2CDevice.write(ref, bus_address, [@aht20_cmd_trigger_measurement, 0x33, 0x00]),
         :ok <- Process.sleep(75) do
      AHT20.I2CDevice.read(ref, bus_address, 7)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Obtains the sensor status byte.
  For more info. please refer to the data sheet (section 5.3).
  """
  @spec read_state(t) :: {:ok, <<_::8>>} | {:error, any}
  def read_state(%{ref: ref, bus_address: bus_address}) do
    AHT20.I2CDevice.write_read(ref, bus_address, [@aht20_cmd_read_state], 1)
  end
end
