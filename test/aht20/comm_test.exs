# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule AHT20.CommTest do
  use ExUnit.Case, async: true

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockTransport, AHT20.Transport.Stub)
    :ok
  end

  test "reset" do
    AHT20.MockTransport
    |> Mox.expect(:write, 1, fn _transport, [0xBA] -> :ok end)

    assert :ok = AHT20.Comm.reset(fake_transport())
  end

  test "init" do
    AHT20.MockTransport
    |> Mox.expect(:write, 1, fn _transport, [0xBE, <<0x08, 0x00>>] -> :ok end)

    assert :ok = AHT20.Comm.init(fake_transport())
  end

  test "measure" do
    AHT20.MockTransport
    |> Mox.expect(:write, 1, fn _transport, [0xAC, <<0x33, 0x00>>] -> :ok end)
    |> Mox.expect(:read, 1, fn _transport, 7 -> {:ok, <<28, 38, 154, 118, 66, 231, 118>>} end)

    assert {:ok, <<28, 38, 154, 118, 66, 231, 118>>} = AHT20.Comm.measure(fake_transport())
  end

  defp fake_transport() do
    %AHT20.Transport{ref: make_ref(), bus_address: 0x00}
  end
end
