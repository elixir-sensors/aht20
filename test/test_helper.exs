Application.put_env(:aht20, :transport_module, AHT20.MockI2C)
Mox.defmock(AHT20.MockI2C, for: AHT20.Transport)

ExUnit.start()
