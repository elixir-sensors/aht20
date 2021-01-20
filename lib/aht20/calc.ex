defmodule AHT20.Calc do
  @doc """
  Calculates the relative humidity in percent.

      iex> AHT20.Calc.relative_humidity(<<28, 38, 154, 118, 66, 231, 118>>)
      15.079402923583984
  """
  @spec relative_humidity(<<_::56>>) :: float
  def relative_humidity(sensor_output), do: humidity_from_sensor_output(sensor_output) / 1_048_576.0 * 100.0

  @doc """
  Calculates the temperature in Celsius.

      iex> AHT20.Calc.celsius(<<28, 38, 154, 118, 66, 231, 118>>)
      28.26671600341797
  """
  @spec celsius(<<_::56>>) :: float
  def celsius(sensor_output), do: temperature_from_sensor_output(sensor_output) / 1_048_576.0 * 200.0 - 50.0

  @doc """
  Calculates the temperature in Fahrenheit.

      iex> AHT20.Calc.fahrenheit(<<28, 38, 154, 118, 66, 231, 118>>)
      82.88008880615234
  """
  @spec fahrenheit(<<_::56>>) :: float
  def fahrenheit(sensor_output), do: celsius(sensor_output) * 9.0 / 5.0 + 32.0

  @doc """
  Obtains the humidity value from the sensor output.

      iex> AHT20.Calc.humidity_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      158119
  """
  @spec humidity_from_sensor_output(<<_::56>>) :: integer()
  def humidity_from_sensor_output(sensor_output) do
    <<_state, hum1, hum2, hum3::4, _temp1::4, _temp2, _temp3, _crc>> = sensor_output
    <<humidity::20>> = <<hum1, hum2, hum3::4>>
    humidity
  end

  @doc """
  Obtains the temperature value from the sensor output.

      iex> AHT20.Calc.temperature_from_sensor_output(<<28, 38, 154, 118, 66, 231, 118>>)
      410343
  """
  @spec temperature_from_sensor_output(<<_::56>>) :: integer()
  def temperature_from_sensor_output(sensor_output) do
    <<_state, _hum1, _hum2, _hum3::4, temp1::4, temp2, temp3, _crc>> = sensor_output
    <<temperature::20>> = <<temp1::4, temp2, temp3>>
    temperature
  end

  @doc """
  Parses the sensor state byte into a human-readable map.

      iex> AHT20.Calc.parse_sensor_state(0b0001_1100)
      %{busy: false, calibrated: true, mode: :nor}
  """
  @spec parse_sensor_state(byte) :: %{busy: boolean, calibrated: boolean, mode: :cmd | :cyc | :nor}
  def parse_sensor_state(state_byte) do
    <<busy::1, mode::2, _::1, cal::1, _::3>> = <<state_byte>>

    %{
      busy: busy == 1,
      mode:
        case mode do
          0 -> :nor
          1 -> :cyc
          _ -> :cmd
        end,
      calibrated: cal == 1
    }
  end
end
