defmodule AHT20 do
  @moduledoc """
  Documentation for `AHT20`.

    ## Examples

      # Detect I2C devices.
      Circuits.I2C.detect_devices

      # Connect to the sensor.
      {:ok, sensor} = AHT20.start()

      # Read humidity and temperature from the sensor.
      {:ok, mearuement} = AHT20.read_data(sensor)

      # Read the sensor state from the sensor.
      {:ok, sensor_state} = AHT20.read_state(sensor)
  """

  @spec start(list | map) :: {:ok, AHT20.Sensor.t()} | {:error, any}
  def start(config) do
    AHT20.Sensor.start(Enum.into(config, %{}))
  end

  @spec read_data(AHT20.Sensor.t()) :: {:ok, AHT20.Measurement.t()} | {:error, any}
  def read_data(sensor) do
    {:ok, sensor_output} = AHT20.Sensor.read_data(sensor)
    {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
  end

  @spec read_state(AHT20.Sensor.t()) :: {:ok, AHT20.State.t()} | {:error, any}
  def read_state(sensor) do
    {:ok, <<sensor_state_byte>>} = AHT20.Sensor.read_state(sensor)
    {:ok, AHT20.State.from_byte(sensor_state_byte)}
  end
end
