# SPDX-FileCopyrightText: 2021 Masatoshi Nishiguchi
#
# SPDX-License-Identifier: Apache-2.0
#
defmodule AHT20.Comm do
  @moduledoc false

  @aht20_cmd_status [0x71]
  @aht20_cmd_soft_reset [0xBA]
  @aht20_cmd_initialize [0xBE, <<0x08, 0x00>>]
  @aht20_cmd_trigger_measurement [0xAC, <<0x33, 0x00>>]

  @spec get_status(AHT20.Transport.t()) :: %{busy: 0 | 1, calibrated: 0 | 1} | {:error, any()}
  def get_status(transport) do
    case transport_mod().write_read(transport, @aht20_cmd_status, 1) do
      {:ok, <<busy::1, _::3, calibrated::1, _::3>>} -> %{busy: busy, calibrated: calibrated}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec calibrated?(AHT20.Transport.t()) :: boolean() | {:error, any()}
  def calibrated?(transport) do
    case get_status(transport) do
      %{calibrated: 1} -> true
      %{calibrated: 0} -> false
      {:error, reason} -> {:error, reason}
    end
  end

  @spec busy?(AHT20.Transport.t()) :: boolean() | {:error, any()}
  def busy?(transport) do
    case get_status(transport) do
      %{busy: 1} -> true
      %{busy: 0} -> false
      {:error, reason} -> {:error, reason}
    end
  end

  @spec reset(AHT20.Transport.t()) :: :ok | {:error, any()}
  def reset(transport) do
    transport_mod().write(transport, @aht20_cmd_soft_reset)
  end

  @spec init(AHT20.Transport.t()) :: :ok | {:error, any()}
  def init(transport) do
    transport_mod().write(transport, @aht20_cmd_initialize)
  end

  @spec measure(AHT20.Transport.t()) :: {:ok, <<_::56>>} | {:error, any()}
  def measure(transport) do
    with :ok <- transport_mod().write(transport, @aht20_cmd_trigger_measurement),
         :ok <- Process.sleep(80) do
      transport_mod().read(transport, 7)
    end
  end

  defp transport_mod() do
    Application.get_env(:aht20, :transport_mod, AHT20.Transport.I2C)
  end
end
