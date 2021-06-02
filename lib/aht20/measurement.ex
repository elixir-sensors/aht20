defmodule AHT20.Measurement do
  @moduledoc """
  One sensor measurement report.
  """

  defstruct [:temperature_c, :humidity_rh, :dew_point_c, :timestamp_ms]

  @type t :: %__MODULE__{
          temperature_c: number,
          humidity_rh: number,
          dew_point_c: number,
          timestamp_ms: number
        }

  @doc """
  Converts raw sensor output into human-readable struct.

      iex> %AHT20.Measurement{} = AHT20.Measurement.from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)

  """
  def from_sensor_output(<<_state, raw_humidity::20, raw_temperature::20, _crc>>) do
    __struct__(
      humidity_rh: AHT20.Calc.humidity_rh_from_raw(raw_humidity),
      temperature_c: AHT20.Calc.temperature_c_from_raw(raw_temperature),
      timestamp_ms: System.monotonic_time(:millisecond)
    )
  end

  def put_dew_point_c(measurement) do
    %{measurement | dew_point_c: AHT20.Calc.dew_point(measurement.humidity_rh, measurement.temperature_c)}
  end
end
