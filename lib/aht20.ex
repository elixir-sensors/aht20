defmodule AHT20 do
  @moduledoc """
  Documentation for `AHT20`.
  """

  def start_(config) do
    {:ok, sensor} = AHT20.Sensor.start()
  end

  def read(sensor) do
    {:ok, output} = AHT20.Sensor.read_data(sensor)

    %{
      relative_humidity: AHT20.Sensor.relative_humidity(output),
      temperature_c: AHT20.Sensor.celsius(output),
      temperature_f: AHT20.Sensor.fahrenheit(output),
      raw_humidity: 0,
      raw_temperature: 0
    }
  end
end
