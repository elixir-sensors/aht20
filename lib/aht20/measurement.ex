defmodule AHT20.Measurement do
  @moduledoc """
  One sensor measurement report
  The raw temperature and humidity values are computed directly from the sensor. All other values are derived.
  """
  defstruct [:temperature_c, :temperature_f, :relative_humidity, :raw_humidity, :raw_temperature]

  @type t :: %__MODULE__{
          temperature_c: number,
          temperature_f: number,
          relative_humidity: number,
          raw_humidity: number,
          raw_temperature: number
        }
end
