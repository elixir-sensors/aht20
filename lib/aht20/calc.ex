defmodule AHT20.Calc do
  @moduledoc false

  @doc """
  Calculates the relative humidity in percent.

      iex> AHT20.Calc.humidity_rh_from_raw(158119)
      15.079402923583984

  """
  @spec humidity_rh_from_raw(integer()) :: float()
  def humidity_rh_from_raw(raw_humidity) do
    raw_humidity / 1_048_576.0 * 100.0
  end

  @doc """
  Calculates the temperature in Celsius.

      iex> AHT20.Calc.temperature_c_from_raw(410343)
      28.26671600341797

  """
  @spec temperature_c_from_raw(integer()) :: float()
  def temperature_c_from_raw(raw_temperature) do
    raw_temperature / 1_048_576.0 * 200.0 - 50.0
  end

  @doc """
  Calculates the temperature in Fahrenheit.

      iex> AHT20.Calc.temperature_f_from_raw(410343)
      82.88008880615234

  """
  @spec temperature_f_from_raw(integer()) :: float()
  def temperature_f_from_raw(raw_temperature) do
    temperature_f_from_temperature_c(temperature_c_from_raw(raw_temperature))
  end

  @doc """
  Convert Celsius to Fahrenheit.

      iex> AHT20.Calc.temperature_f_from_temperature_c(28.26671600341797)
      82.88008880615234

  """
  @spec temperature_f_from_temperature_c(number()) :: float()
  def temperature_f_from_temperature_c(temperature_c) do
    temperature_c * 9.0 / 5.0 + 32.0
  end

  @doc """
  Calculate the dew point
  This uses the August–Roche–Magnus approximation. See
  https://en.wikipedia.org/wiki/Clausius%E2%80%93Clapeyron_relation#Meteorology_and_climatology
  """
  @spec dew_point(number(), number()) :: float()
  def dew_point(humidity_rh, temperature_c) when is_number(humidity_rh) and humidity_rh > 0 do
    log_rh = :math.log(humidity_rh / 100)
    t = temperature_c

    243.04 * (log_rh + 17.625 * t / (243.04 + t)) / (17.625 - log_rh - 17.625 * t / (243.04 + t))
  end
end
