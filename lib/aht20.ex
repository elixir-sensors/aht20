defmodule AHT20 do
  @moduledoc """
  A collection of convenient functions to use this library.
  """

  @spec start(AHT20.Sensor.config()) :: {:ok, AHT20.Sensor.t()} | {:error, any}
  def start(config) do
    AHT20.Sensor.start(config)
  end

  @spec start_link(AHT20.Sensor.config()) :: {:ok, pid} | {:error, any}
  def start_link(config) do
    AHT20.SensorWorker.start_link(config)
  end

  @spec read(pid) :: {:ok, AHT20.Measurement.t()} | {:error, any}
  def read(pid), do: read_data(pid)

  @spec read_data(pid) :: {:ok, AHT20.Measurement.t()} | {:error, any}
  def read_data(pid) when is_pid(pid) do
    AHT20.SensorWorker.read_data(pid)
  end

  @spec read_data(AHT20.Sensor.t()) :: {:ok, AHT20.Measurement.t()} | {:error, any}
  def read_data(%AHT20.Sensor{} = sensor) when is_struct(sensor) do
    {:ok, sensor_output} = AHT20.Sensor.read_data(sensor)
    {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
  end

  @spec read_state(pid) :: {:ok, AHT20.State.t()} | {:error, any}
  def read_state(pid) when is_pid(pid) do
    AHT20.SensorWorker.read_state(pid)
  end

  @spec read_state(AHT20.Sensor.t()) :: {:ok, AHT20.State.t()} | {:error, any}
  def read_state(%AHT20.Sensor{} = sensor) when is_struct(sensor) do
    {:ok, <<sensor_state_byte>>} = AHT20.Sensor.read_state(sensor)
    {:ok, AHT20.State.from_byte(sensor_state_byte)}
  end
end
