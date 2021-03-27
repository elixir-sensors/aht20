defmodule AHT20 do
  @moduledoc """
  Read temperature and humidity from a AHT20 sensor.
  """

  use GenServer

  @typedoc """
  AHT20 GenServer start_link options
  * `:name` - a name for the GenServer
  * `:bus_name` - which I2C bus to use (e.g., `"i2c-1"`)
  * `:bus_address` - the address of the AHT20 (defaults to 0x38)
  """
  @type options() ::
          [
            name: GenServer.name()
          ]
          | AHT20.Sensor.config()

  @doc """
  Detect devices on I2C buses.
  """
  def detect_device(), do: Circuits.I2C.detect_devices()

  @doc """
  Start a new GenServer for interacting with a AHT20.
  Normally, you'll want to pass the `:bus_name` option to specify the I2C
  bus going to the AHT20.
  """
  @spec start_link(options()) :: GenServer.on_start()
  def start_link(init_arg) do
    options = Keyword.take(init_arg, [:name])
    GenServer.start_link(__MODULE__, init_arg, options)
  end

  def measure(server \\ __MODULE__), do: GenServer.call(server, :measure)

  @deprecated "Use AHT20.measure/1 instead"
  def read(server \\ __MODULE__), do: measure(server)

  @deprecated "Use AHT20.measure/1 instead"
  def read_data(server \\ __MODULE__), do: measure(server)

  @deprecated "Will be removed in next release"
  def read_state(server \\ __MODULE__), do: GenServer.call(server, :read_state)

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
