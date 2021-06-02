defmodule AHT20.SensorTest do
  use ExUnit.Case, async: true

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockI2C, AHT20.Transport.I2C.Stub)
    :ok
  end

  test "init" do
    assert :ok = AHT20.Sensor.init(fake_transport())
  end

  test "measure" do
    AHT20.MockI2C
    |> Mox.expect(:read, 1, fn _transport, _register ->
      {:ok, <<28, 38, 154, 118, 66, 231, 118>>}
    end)

    result = AHT20.Sensor.measure(fake_transport())

    assert {:ok,
            %AHT20.Measurement{
              humidity_rh: 15.079402923583984,
              temperature_c: 28.26671600341797,
              temperature_f: 82.88008880615234
            }} == result
  end

  defp fake_transport do
    :c.pid(0, 0, 0)
  end
end
