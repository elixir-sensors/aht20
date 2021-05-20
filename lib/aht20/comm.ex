defmodule AHT20.Comm do
  @moduledoc false

  @aht20_cmd_soft_reset [0xBA]
  @aht20_cmd_initialize [0xBE, <<0x08, 0x00>>]
  @aht20_cmd_trigger_measurement [0xAC, <<0x33, 0x00>>]

  def reset(transport) do
    AHT20.Transport.I2C.write(transport, @aht20_cmd_soft_reset)
  end

  def init(transport) do
    AHT20.Transport.I2C.write(transport, @aht20_cmd_initialize)
  end

  def measure(transport) do
    with :ok <- AHT20.Transport.I2C.write(transport, @aht20_cmd_trigger_measurement),
         :ok <- Process.sleep(80) do
      AHT20.Transport.I2C.read(transport, 7)
    end
  end
end
