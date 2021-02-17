defmodule AHT20.Calc do
  @moduledoc """
  A collection of calculation functions.
  """

  @doc """
  Calculates the relative humidity in percent.

      iex> AHT20.Calc.humidity_rh_from_raw(158119)
      15.079402923583984
  """
  @spec humidity_rh_from_raw(integer) :: float
  def humidity_rh_from_raw(raw_humidity), do: raw_humidity / 1_048_576.0 * 100.0

  @doc """
  Calculates the temperature in Celsius.

      iex> AHT20.Calc.temperature_c_from_raw(410343)
      28.26671600341797
  """
  @spec temperature_c_from_raw(integer) :: float
  def temperature_c_from_raw(raw_temperature), do: raw_temperature / 1_048_576.0 * 200.0 - 50.0

  @doc """
  Calculates the temperature in Fahrenheit.

      iex> AHT20.Calc.temperature_f_from_raw(410343)
      82.88008880615234
  """
  @spec temperature_f_from_raw(integer) :: float
  def temperature_f_from_raw(raw_temperature) do
    temperature_c_from_raw(raw_temperature) * 9.0 / 5.0 + 32.0
  end
end
