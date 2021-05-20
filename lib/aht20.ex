defmodule AHT20 do
  @moduledoc """
  Read temperature and humidity from AHT20 sensor in Elixir.
  """

  use GenServer

  @typedoc """
  AHT20 GenServer start_link options
  * `:name` - a name for the GenServer
  * `:bus_name` - which I2C bus to use (defaults to `"i2c-1"`)
  * `:bus_address` - the address of the AHT20 (defaults to 0x38)
  """
  @type options() ::
          [
            name: GenServer.name()
          ]
          | AHT20.Sensor.config()

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

  def measure(server), do: GenServer.call(server, :measure)

  @impl true
  def init(config) do
    case AHT20.Sensor.init(config) do
      {:ok, sensor} -> {:ok, sensor}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl true
  def handle_call(:measure, _from, sensor) do
    result = AHT20.Sensor.measure(sensor)
    {:reply, result, sensor}
  end
end
