defmodule AHT20.SensorTest do
  use ExUnit.Case

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockI2C, AHT20.I2CDevice.Stub)
    :ok
  end

  test "start" do
    assert {:ok, %AHT20.Sensor{bus_address: 0x38, ref: _}} = AHT20.Sensor.start()
  end

  test "reset" do
    sensor = %AHT20.Sensor{bus_address: 0x38, ref: make_ref()}
    assert :ok = AHT20.Sensor.reset(sensor)
  end

  test "read_data" do
    AHT20.MockI2C
    |> Mox.expect(:read, 1, fn _ref, _address, _data -> {:ok, <<28, 38, 154, 118, 66, 231, 118>>} end)

    sensor = %AHT20.Sensor{bus_address: 0x38, ref: make_ref()}
    assert {:ok, <<28, 38, 154, 118, 66, 231, 118>>} = AHT20.Sensor.read_data(sensor)
  end

  test "read_state" do
    AHT20.MockI2C
    |> Mox.expect(:write_read, 1, fn _ref, _address, _data, _bytes_to_read -> {:ok, <<0b00011100>>} end)

    sensor = %AHT20.Sensor{bus_address: 0x38, ref: make_ref()}
    assert {:ok, <<28>>} = AHT20.Sensor.read_state(sensor)
  end
end
