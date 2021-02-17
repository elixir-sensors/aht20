defmodule AHT20 do
  @moduledoc """
  Wraps a sensor, holding a connection.
  """

  use GenServer

  @spec start_link(AHT20.Sensor.config()) :: GenServer.on_start()
  def start_link(config), do: GenServer.start_link(__MODULE__, config)

  def read(pid), do: read_data(pid)

  def read_data(pid), do: GenServer.call(pid, :read_data)

  def read_state(pid), do: GenServer.call(pid, :read_state)

  @impl true
  def init(config) do
    {:ok, _sensor} = AHT20.Sensor.start(config)
  end

  @impl true
  def handle_call(:read_data, _from, sensor) do
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
      {:ok, <<sensor_state_byte>>} ->
        sensor_state = AHT20.State.from_byte(sensor_state_byte)
        {:reply, {:ok, sensor_state}, sensor}

      {:error, reason} ->
        {:reply, {:error, reason}, sensor}
    end
  end
end
