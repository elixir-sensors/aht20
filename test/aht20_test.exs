defmodule AHT20Test do
  use ExUnit.Case

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "start" do
    AHT20.MockI2C
    |> expect(:write, 2, fn _ref, _address, _data, [] -> :ok end)
    |> expect(:open, 1, fn _i2c_bus -> {:ok, Kernel.make_ref()} end)

    config = [i2c_bus: "i2c-1", i2c_address: 0x38]
    assert {:ok, %AHT20.Sensor{i2c_address: 0x38, i2c_bus: "i2c-1", i2c_ref: _}} = AHT20.start(config)
  end

  test "read_data" do
    AHT20.MockI2C
    |> expect(:write, 1, fn _ref, _address, _data, [] -> :ok end)
    |> expect(:read, 1, fn _ref, _address, _data, [] -> {:ok, <<28, 38, 154, 118, 66, 231, 118>>} end)

    sensor = %AHT20.Sensor{i2c_address: 0x38, i2c_bus: "i2c-1", i2c_ref: make_ref()}
    assert {:ok, data} = AHT20.read_data(sensor)

    assert data == %AHT20.Measurement{
             raw_humidity: 158_119,
             raw_temperature: 410_343,
             relative_humidity: 15.079402923583984,
             temperature_c: 28.26671600341797,
             temperature_f: 82.88008880615234
           }
  end

  test "read_state" do
    AHT20.MockI2C
    |> expect(:write_read, 1, fn _ref, _address, _data, _bytes_to_read, [] -> {:ok, <<0b00011100>>} end)

    sensor = %AHT20.Sensor{i2c_address: 0x38, i2c_bus: "i2c-1", i2c_ref: make_ref()}
    assert {:ok, state} = AHT20.read_state(sensor)
    assert state == %AHT20.State{busy: false, calibrated: true, mode: :nor}
  end
end
