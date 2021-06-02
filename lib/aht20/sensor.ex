defmodule AHT20.Sensor do
  @moduledoc false

  @spec init(pid) :: :ok | {:error, any}
  def init(transport) do
    with :ok <- AHT20.Comm.reset(transport),
         :ok <- Process.sleep(10),
         :ok <- AHT20.Comm.init(transport) do
      :ok
    end
  end

  @spec measure(pid) :: {:ok, map} | {:error, any}
  def measure(transport) do
    with {:ok, sensor_output} <- AHT20.Comm.measure(transport) do
      {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
    end
  end
end
