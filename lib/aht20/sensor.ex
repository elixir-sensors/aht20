defmodule AHT20.Sensor do
  @moduledoc """
  Abstracts the basic operations of the temperature and humidity sensor AHT20.

  For the ADT20 specifications, please refer to the [AHT20 data sheet](https://cdn.sparkfun.com/assets/d/2/b/e/d/AHT20.pdf).

  ## Examples

      Circuits.I2C.detect_devices

      {:ok, sensor} = AHT20.Sensor.start()

      {:ok, output} = AHT20.Sensor.read_data(sensor)
      output |> AHT20.Sensor.relative_humidity()
      output |> AHT20.Sensor.celsius()
      output |> AHT20.Sensor.fahrenheit()

      AHT20.Sensor.read_state(sensor)
  """

  require Logger

  use Bitwise, only_operators: true

  @default_i2c_bus "i2c-1"
  @default_i2c_address 0x38

  @aht20_cmd_initialize 0xBE
  @aht20_cmd_trigger_measurement 0xAC
  @aht20_cmd_soft_reset 0xBA
  @aht20_cmd_read_state 0x71

  @type i2c_bus :: Circuit.I2C.bus()
  @type i2c_address :: Circuit.I2C.address()

  @typedoc """
  The configuration options.
  """
  @type config :: %{
          optional(:i2c_bus) => i2c_bus,
          optional(:i2c_address) => i2c_address
        }

  defstruct [:i2c_bus, :i2c_ref, :i2c_address]

  @typedoc """
  The internal state.
  """
  @type t :: %__MODULE__{
          i2c_bus: i2c_bus,
          i2c_ref: reference,
          i2c_address: i2c_address
        }

  @doc """
  For more info. please refer to the data sheet (section 5.4).
  """
  @spec start(config) :: {:ok, t} | {:error, any}
  def start(config \\ %{}) do
    i2c_bus = config[:i2c_bus] || @default_i2c_bus
    i2c_address = config[:i2c_address] || @default_i2c_address

    {:ok, i2c_ref} = Circuits.I2C.open(i2c_bus)

    aht20 =
      __struct__(
        i2c_bus: i2c_bus,
        i2c_ref: i2c_ref,
        i2c_address: i2c_address
      )

    Process.sleep(40)
    :ok = reset(aht20)
    :ok = init(aht20)
    {:ok, aht20}
  rescue
    e -> {:error, e}
  end

  @doc """
  Restarts the sensor system without having to turn off and turn on the power again.
  For more info. please refer to the data sheet (section 5.5).
  """
  @spec reset(t) :: :ok | {:error, any}
  def reset(%{i2c_ref: i2c_ref, i2c_address: i2c_address}) do
    :ok = Circuits.I2C.write(i2c_ref, i2c_address, [@aht20_cmd_soft_reset])
    Process.sleep(20)
    :ok
  rescue
    e -> {:error, e}
  end

  # Initialize the sensor system.
  # For more info. please refer to the data sheet (section 5.4).
  @spec init(t) :: :ok | :no_return
  defp init(%{i2c_ref: i2c_ref, i2c_address: i2c_address}) do
    :ok = Circuits.I2C.write(i2c_ref, i2c_address, [@aht20_cmd_initialize, 0x08, 0x00])
  end

  @doc """
  Triggers the sensor to read temperature and humidity.
  """
  @spec read_data(t) :: {:ok, <<_::56>>} | {:error, any}
  def read_data(%{i2c_ref: i2c_ref, i2c_address: i2c_address}) do
    :ok = Circuits.I2C.write(i2c_ref, i2c_address, [@aht20_cmd_trigger_measurement, 0x33, 0x00])
    Process.sleep(75)
    {:ok, _sensor_output} = Circuits.I2C.read(i2c_ref, i2c_address, 7)
  rescue
    e -> {:error, e}
  end

  @doc """
  Obtains the sensor status byte.
  For more info. please refer to the data sheet (section 5.3).
  """
  @spec read_state(t) :: map | {:error, any}
  def read_state(%{i2c_ref: i2c_ref, i2c_address: i2c_address}) do
    {:ok, <<sensor_state>>} = Circuits.I2C.write_read(i2c_ref, i2c_address, [@aht20_cmd_read_state], 1)
    parse_sensor_state(sensor_state)
  rescue
    e -> {:error, e}
  end

  @doc """
  Calculates the relative humidity in percent.

      iex> AHT20.Sensor.relative_humidity(<<28, 38, 154, 118, 66, 231, 118>>)
      15.079402923583984
  """
  @spec relative_humidity(<<_::56>>) :: float
  def relative_humidity(sensor_output), do: humidity_from_sensor_output(sensor_output) / 1_048_576.0 * 100.0

  @doc """
  Calculates the temperature in Celsius.

      iex> AHT20.Sensor.celsius(<<28, 38, 154, 118, 66, 231, 118>>)
      28.26671600341797
  """
  @spec celsius(<<_::56>>) :: float
  def celsius(sensor_output), do: temperature_from_sensor_output(sensor_output) / 1_048_576.0 * 200.0 - 50.0

  @doc """
  Calculates the temperature in Fahrenheit.

      iex> AHT20.Sensor.fahrenheit(<<28, 38, 154, 118, 66, 231, 118>>)
      82.88008880615234
  """
  @spec fahrenheit(<<_::56>>) :: float
  def fahrenheit(sensor_output), do: celsius(sensor_output) * 9.0 / 5.0 + 32.0

  @doc """
  Obtains the humidity value from the sensor output.

      iex> AHT20.Sensor.humidity_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      158119
  """
  @spec humidity_from_sensor_output(<<_::56>>) :: integer()
  def humidity_from_sensor_output(sensor_output) do
    <<_state, hum1, hum2, hum3::4, _temp1::4, _temp2, _temp3, _crc>> = sensor_output
    <<humidity::20>> = <<hum1, hum2, hum3::4>>
    humidity
  end

  @doc """
  Obtains the temperature value from the sensor output.

      iex> AHT20.Sensor.temperature_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      410343
  """
  @spec temperature_from_sensor_output(<<_::56>>) :: integer()
  def temperature_from_sensor_output(sensor_output) do
    <<_state, _hum1, _hum2, _hum3::4, temp1::4, temp2, temp3, _crc>> = sensor_output
    <<temperature::20>> = <<temp1::4, temp2, temp3>>
    temperature
  end

  @doc """
  Parses the sensor state byte into a human-readable map.

      iex> AHT20.Sensor.parse_sensor_state(0b0001_1100)
      %{busy: false, calibrated: true, mode: :nor}
  """
  @spec parse_sensor_state(byte) :: %{busy: boolean, calibrated: boolean, mode: :cmd | :cyc | :nor}
  def parse_sensor_state(state_byte) do
    <<busy::1, mode::2, _::1, cal::1, _::3>> = <<state_byte>>

    %{
      busy: busy == 1,
      mode:
        case mode do
          0 -> :nor
          1 -> :cyc
          _ -> :cmd
        end,
      calibrated: cal == 1
    }
  end
end
