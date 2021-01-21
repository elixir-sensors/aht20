# AHT20

[![Hex.pm](https://img.shields.io/hexpm/v/aht20.svg)](https://hex.pm/packages/aht20)
[![API docs](https://img.shields.io/hexpm/v/aht20.svg?label=docs)](https://hexdocs.pm/aht20)
![CI](https://github.com/mnishiguchi/AHT20/workflows/CI/badge.svg)

Use [AHT20](http://www.aosong.com/en/products-32.html) temperature & humidity sensor in Elixir.

## Usage

Here's an example use:

```elixir
# Detect I2C devices.
iex> Circuits.I2C.detect_devices()
Devices on I2C bus "i2c-1":
 * 56  (0x38)

1 devices detected on 1 I2C buses

# Connect to the sensor.
iex> {:ok, aht20} = AHT20.start(bus_name: "i2c-1", bus_address: 0x38)
{:ok, AHT20.Sensor{}}

# Read the humidity and temperature from the sensor.
iex> AHT20.read_data(aht20)
{:ok,
 %AHT20.Measurement{
   raw_humidity: 158_119,
   raw_temperature: 410_343,
   relative_humidity: 15.079402923583984,
   temperature_c: 28.26671600341797,
   temperature_f: 82.88008880615234
 }}
```

Depending on your hardware configuration, you may need to modify the call to
`AHT20.start/1`. See `t:AHT20.Sensor.config/0` for parameters.
