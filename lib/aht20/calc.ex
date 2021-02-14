defmodule AHT20.Calc do
  @moduledoc """
  A collection of calculation functions.
  """

  @doc """
  Calculates the relative humidity in percent.

      iex> AHT20.Calc.relative_humidity(158119)
      15.079402923583984
  """
  @spec relative_humidity(integer) :: float
  def relative_humidity(raw_humidity), do: raw_humidity / 1_048_576.0 * 100.0

  @doc """
  Calculates the temperature in Celsius.

      iex> AHT20.Calc.celsius_from_raw_temperature(410343)
      28.26671600341797
  """
  @spec celsius_from_raw_temperature(integer) :: float
  def celsius_from_raw_temperature(raw_temperature), do: raw_temperature / 1_048_576.0 * 200.0 - 50.0

  @doc """
  Calculates the temperature in Fahrenheit.

      iex> AHT20.Calc.fahrenheit_from_raw_temperature(410343)
      82.88008880615234
  """
  @spec fahrenheit_from_raw_temperature(integer) :: float
  def fahrenheit_from_raw_temperature(raw_temperature) do
    celsius_from_raw_temperature(raw_temperature) * 9.0 / 5.0 + 32.0
  end

  @doc """
  Obtains the humidity value from the sensor output.

      iex> AHT20.Calc.raw_humidity_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      158119
  """
  @spec raw_humidity_from_sensor_output(<<_::56>>) :: integer()
  def raw_humidity_from_sensor_output(<<_state, humidity::20, _temperature::20, _crc>>) do
    humidity
  end

  @doc """
  Obtains the temperature value from the sensor output.

      iex> AHT20.Calc.raw_temperature_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      410343
  """
  @spec raw_temperature_from_sensor_output(<<_::56>>) :: integer()
  def raw_temperature_from_sensor_output(<<_state, _humidity::20, temperature::20, _crc>>) do
    temperature
  end
end
