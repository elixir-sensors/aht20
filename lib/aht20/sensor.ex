# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule AHT20.Sensor do
  @moduledoc false

  @spec init(AHT20.Transport.t()) :: :ok | {:error, any()}
  def init(transport) do
    with :ok <- AHT20.Comm.reset(transport),
         :ok <- Process.sleep(10) do
      AHT20.Comm.init(transport)
    end
  end

  @spec measure(AHT20.Transport.t()) :: {:ok, AHT20.Measurement.t()} | {:error, any()}
  def measure(transport) do
    with {:ok, sensor_output} <- AHT20.Comm.measure(transport) do
      {:ok, AHT20.Measurement.from_sensor_output(sensor_output)}
    end
  end
end
