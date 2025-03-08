# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
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
  Converts raw sensor output into human-readable format.

      iex> measurement = AHT20.Measurement.from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      ...> measurement.temperature_c
      28.26671600341797

  """
  @spec from_sensor_output(<<_::56>>) :: t()
  def from_sensor_output(<<_state, raw_humidity::20, raw_temperature::20, _crc>>) do
    __struct__(
      humidity_rh: AHT20.Calc.humidity_rh_from_raw(raw_humidity),
      temperature_c: AHT20.Calc.temperature_c_from_raw(raw_temperature),
      timestamp_ms: System.monotonic_time(:millisecond)
    )
    |> put_dew_point_c()
  end

  @spec put_dew_point_c(t()) :: t()
  defp put_dew_point_c(measurement) do
    %{
      measurement
      | dew_point_c: AHT20.Calc.dew_point(measurement.humidity_rh, measurement.temperature_c)
    }
  end
end
