defmodule AHT20.Comm do
  @moduledoc false

  @aht20_cmd_status [0x71]
  @aht20_cmd_soft_reset [0xBA]
  @aht20_cmd_initialize [0xBE, <<0x08, 0x00>>]
  @aht20_cmd_trigger_measurement [0xAC, <<0x33, 0x00>>]

  def get_status(transport) do
    case transport_mod().write_read(transport, @aht20_cmd_status, 1) do
      {:ok, <<busy::1, _::3, calibrated::1, _::3>>} -> %{busy: busy, calibrated: calibrated}
      {:error, reason} -> {:error, reason}
    end
  end

  def calibrated?(transport) do
    case get_status(transport) do
      %{calibrated: 1} -> true
      %{calibrated: 0} -> false
      {:error, reason} -> {:error, reason}
    end
  end

  def busy?(transport) do
    case get_status(transport) do
      %{busy: 1} -> true
      %{busy: 0} -> false
      {:error, reason} -> {:error, reason}
    end
  end

  def reset(transport) do
    transport_mod().write(transport, @aht20_cmd_soft_reset)
  end

  def init(transport) do
    transport_mod().write(transport, @aht20_cmd_initialize)
  end

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
