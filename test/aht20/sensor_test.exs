# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule AHT20.SensorTest do
  use ExUnit.Case, async: true

  # https://hexdocs.pm/mox/Mox.html
  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  setup do
    Mox.stub_with(AHT20.MockTransport, AHT20.Transport.Stub)
    :ok
  end

  test "init" do
    assert :ok = AHT20.Sensor.init(fake_transport())
  end

  test "measure" do
    AHT20.MockTransport
    |> Mox.expect(:read, 1, fn _transport, _register ->
      {:ok, <<28, 113, 191, 6, 86, 169, 149>>}
    end)

    result = AHT20.Sensor.measure(fake_transport())

    assert {:ok,
            %AHT20.Measurement{
              dew_point_c: 15.881025820111912,
              humidity_rh: 44.43206787109375,
              temperature_c: 29.23145294189453,
              timestamp_ms: _
            }} = result
  end

  defp fake_transport() do
    %AHT20.Transport{ref: make_ref(), bus_address: 0x00}
  end
end
