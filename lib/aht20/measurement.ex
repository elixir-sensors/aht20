defmodule AHT20.Measurement do
  @moduledoc """
  One sensor measurement report
  The raw temperature and humidity values are computed directly from the sensor. All other values are derived.
  """

  import AHT20.Calc

  defstruct [:temperature_c, :temperature_f, :relative_humidity, :raw_humidity, :raw_temperature]

  @type t :: %__MODULE__{
          temperature_c: number,
          temperature_f: number,
          relative_humidity: number,
          raw_humidity: number,
          raw_temperature: number
        }

  @doc """
  Converts raw sensor output into human-readable format.

      iex> AHT20.Measurement.from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      %{raw_humidity: 158119,
        raw_temperature: 410343,
        relative_humidity: 15.079402923583984,
        temperature_c: 28.26671600341797,
        temperature_f: 82.88008880615234}
  """
  def from_sensor_output(sensor_output) do
    raw_humidity = AHT20.Calc.raw_humidity_from_sensor_output(sensor_output)
    raw_temperature = AHT20.Calc.raw_temperature_from_sensor_output(sensor_output)

    %{
      relative_humidity: relative_humidity(raw_humidity),
      temperature_c: celsius_from_raw_temperature(raw_temperature),
      temperature_f: fahrenheit_from_raw_temperature(raw_temperature),
      raw_humidity: raw_humidity,
      raw_temperature: raw_temperature
    }
  end
end
