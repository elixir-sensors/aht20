defmodule AHT20 do
  @moduledoc false

  @spec start_link(AHT20.Sensor.config()) :: {:ok, pid} | {:error, any}
  def start_link(config) do
    AHT20.SensorWorker.start_link(config)
  end

  @spec read_data() :: {:ok, AHT20.Measurement.t()} | {:error, any}
  def read_data() do
    AHT20.SensorWorker.read_data()
  end

  @spec read_state() :: {:ok, AHT20.State.t()} | {:error, any}
  def read_state() do
    AHT20.SensorWorker.read_state()
  end
end
