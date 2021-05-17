defmodule AHT20.SensorTest do
  use ExUnit.Case

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockI2C, AHT20.Transport.I2C.Stub)
    :ok
  end

  test "init" do
    assert {:ok, %AHT20.Sensor{bus_address: 0x38, transport: _}} = AHT20.Sensor.init()
    assert {:ok, %AHT20.Sensor{bus_address: 0x38, transport: _}} = AHT20.Sensor.init(bus_address: 0x38)

    assert {:ok, %AHT20.Sensor{bus_address: 0x38, transport: _}} =
             AHT20.Sensor.init(bus_name: "i2c-1", bus_address: 0x38)
  end

  test "measure" do
    AHT20.MockI2C
    |> Mox.expect(:read, 1, fn _transport, _register ->
      {:ok, <<28, 38, 154, 118, 66, 231, 118>>}
    end)

    sensor = %AHT20.Sensor{bus_address: 0x38, transport: :c.pid(0, 0, 0)}

    assert {:ok,
            %AHT20.Measurement{
              humidity_rh: 15.079402923583984,
              temperature_c: 28.26671600341797,
              temperature_f: 82.88008880615234
            }} = AHT20.Sensor.measure(sensor)
  end
end
