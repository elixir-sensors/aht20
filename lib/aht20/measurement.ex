defmodule AHT20.Measurement do
  @moduledoc """
  One sensor measurement report.
  """

  defstruct [:temperature_c, :temperature_f, :humidity_rh, :raw_humidity, :raw_temperature]

  @type t :: %__MODULE__{
          temperature_c: number,
          temperature_f: number,
          humidity_rh: number
        }

  @doc """
  Converts raw sensor output into human-readable format.

      iex> AHT20.Measurement.from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      %AHT20.Measurement{
        humidity_rh: 15.079402923583984,
        temperature_c: 28.26671600341797,
        temperature_f: 82.88008880615234
      }
  """
  def from_sensor_output(<<_state, raw_humidity::20, raw_temperature::20, _crc>>) do
    __struct__(
      humidity_rh: AHT20.Calc.humidity_rh_from_raw(raw_humidity),
      temperature_c: AHT20.Calc.temperature_c_from_raw(raw_temperature),
      temperature_f: AHT20.Calc.temperature_f_from_raw(raw_temperature)
    )
  end
end
