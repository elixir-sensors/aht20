defmodule AHT20 do
  @moduledoc """
  Read temperature and humidity from a AHT20 sensor
  """

  use GenServer

  def detect_device(), do: Circuits.I2C.detect_devices()

  @spec start_link(AHT20.Sensor.config()) :: GenServer.on_start()
  def start_link(config), do: GenServer.start_link(__MODULE__, config)

  def measure(pid), do: GenServer.call(pid, :measure)

  @deprecated "Use AHT20.measure/1 instead"
  def read(server), do: measure(server)

  @deprecated "Use AHT20.measure/1 instead"
  def read_data(server), do: measure(server)

  @deprecated "Will be removed in next release"
  def read_state(pid), do: GenServer.call(pid, :read_state)

  @impl true
  def init(config) do
    {:ok, _sensor} = AHT20.Sensor.start(config)
  end

  @impl true
  def handle_call(:measure, _from, sensor) do
    case AHT20.Sensor.read_data(sensor) do
      {:ok, sensor_output} ->
        measurement = AHT20.Measurement.from_sensor_output(sensor_output)
        {:reply, {:ok, measurement}, sensor}

      {:error, reason} ->
        {:reply, {:error, reason}, sensor}
    end
  end

  @impl true
  def handle_call(:read_state, _from, sensor) do
    case AHT20.Sensor.read_state(sensor) do
      {:ok, sensor_output} ->
        sensor_state = AHT20.State.from_sensor_output(sensor_output)
        {:reply, {:ok, sensor_state}, sensor}

      {:error, reason} ->
        {:reply, {:error, reason}, sensor}
    end
  end
end
