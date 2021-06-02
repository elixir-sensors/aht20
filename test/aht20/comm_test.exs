defmodule AHT20.CommTest do
  use ExUnit.Case, async: true

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockI2C, AHT20.Transport.I2C.Stub)
    %{transport: :c.pid(0, 0, 0)}
  end

  test "reset", %{transport: transport} do
    AHT20.MockI2C
    |> Mox.expect(:write, 1, fn _transport, [0xBA] -> :ok end)

    assert :ok = AHT20.Comm.reset(transport)
  end

  test "init", %{transport: transport} do
    AHT20.MockI2C
    |> Mox.expect(:write, 1, fn _transport, [0xBE, <<0x08, 0x00>>] -> :ok end)

    assert :ok = AHT20.Comm.init(transport)
  end

  test "measure", %{transport: transport} do
    AHT20.MockI2C
    |> Mox.expect(:write, 1, fn _transport, [0xAC, <<0x33, 0x00>>] -> :ok end)
    |> Mox.expect(:read, 1, fn _transport, 7 -> {:ok, <<28, 38, 154, 118, 66, 231, 118>>} end)

    assert {:ok, <<28, 38, 154, 118, 66, 231, 118>>} = AHT20.Comm.measure(transport)
  end
end
