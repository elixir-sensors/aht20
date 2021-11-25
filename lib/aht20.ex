defmodule AHT20 do
  @moduledoc """
  Read temperature and humidity from AHT20 sensor in Elixir.
  """

  use GenServer

  require Logger

  @default_bus_name "i2c-1"
  @aht20_address 0x38

  @type bus_name :: binary

  @typedoc """
  AHT20 GenServer start_link options
  * `:name` - a name for the GenServer
  * `:bus_name` - which I2C bus to use (defaults to `"i2c-1"`)
  """
  @type option() :: {:name, GenServer.name()} | {:bus_name, bus_name}

  @doc """
  Start a new GenServer for interacting with a AHT20.
  Normally, you'll want to pass the `:bus_name` option to specify the I2C
  bus going to the AHT20.
  """
  @spec start_link([option()]) :: GenServer.on_start()
  def start_link(init_arg \\ []) do
    GenServer.start_link(__MODULE__, init_arg, name: init_arg[:name])
  end

  def measure(server), do: GenServer.call(server, :measure)

  @impl GenServer
  def init(config) do
    bus_name = config[:bus_name] || @default_bus_name

    Logger.info("[AHT20] Starting on bus #{bus_name} at address #{inspect(@aht20_address, base: :hex)}")

    case transport_mod().open(bus_name: bus_name, bus_address: @aht20_address) do
      {:ok, transport} ->
        {:ok, %{transport: transport}, {:continue, :init_sensor}}

      error ->
        raise("Error opening i2c: #{inspect(error)}")
    end
  end

  @impl GenServer
  def handle_continue(:init_sensor, state) do
    Logger.info("[AHT20] Initializing sensor")

    case AHT20.Sensor.init(state.transport) do
      :ok ->
        {:noreply, state}

      error ->
        raise("Error initializing sensor: #{inspect(error)}")
    end
  end

  @impl GenServer
  def handle_call(:measure, _from, state) do
    {:reply, AHT20.Sensor.measure(state.transport), state}
  end

  defp transport_mod() do
    Application.get_env(:aht20, :transport_mod, AHT20.Transport.I2C)
  end
end
