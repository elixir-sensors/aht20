defmodule AHT20Test do
  use ExUnit.Case

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Any process can consume mocks and stubs defined in your tests.
  setup :set_mox_from_context

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockI2C, AHT20.I2C.Stub)
    :ok
  end

  test "start_link" do
    config = [i2c_bus: "i2c-1", i2c_address: 0x38]
    assert {:ok, _} = AHT20.start_link(config)
  end

  test "read_data" do
    AHT20.MockI2C
    |> Mox.expect(:read, 1, fn _ref, _address, _data, [] -> {:ok, <<28, 38, 154, 118, 66, 231, 118>>} end)

    assert {:ok, _pid} = AHT20.start_link(i2c_bus: "i2c-1", i2c_address: 0x38)
    assert {:ok, data} = AHT20.read_data()

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
    |> Mox.expect(:write_read, 1, fn _ref, _address, _data, _bytes_to_read, [] -> {:ok, <<0b00011100>>} end)

    AHT20.start_link(i2c_bus: "i2c-1", i2c_address: 0x38)
    assert {:ok, state} = AHT20.read_state()
    assert state == %AHT20.State{busy: false, calibrated: true, mode: :nor}
  end
end
