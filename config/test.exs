import Config

# Use the mocks defined in test/support/mocks.ex
# https://hexdocs.pm/mox/Mox.html
config :aht20, transport_module: AHT20.MockI2C
