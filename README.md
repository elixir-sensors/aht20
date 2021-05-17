# AHT20

[![Hex.pm](https://img.shields.io/hexpm/v/aht20.svg)](https://hex.pm/packages/aht20)
[![API docs](https://img.shields.io/hexpm/v/aht20.svg?label=docs)](https://hexdocs.pm/aht20)
[![CI](https://github.com/mnishiguchi/AHT20/workflows/CI/badge.svg)](https://github.com/mnishiguchi/AHT20/actions)

Use [AHT20](http://www.aosong.com/en/products-32.html) temperature & humidity sensor in Elixir.

[![](https://user-images.githubusercontent.com/7563926/107892310-44c78700-6ef2-11eb-996c-0a7580d0ed1d.jpg)](https://www.google.com/search?q=aht20+sensor&tbm=isch)

## Usage

Here's an example use:

```elixir
# Detect I2C devices.
iex> Circuits.I2C.detect_devices()
Devices on I2C bus "i2c-1":
 * 56  (0x38)

1 devices detected on 1 I2C buses

# Connect to the sensor.
iex> {:ok, pid} = AHT20.start_link(bus_name: "i2c-1", bus_address: 0x38)
{:ok, #PID<0.1407.0>}

# Read the humidity and temperature from the sensor.
iex> AHT20.measure(pid)
{:ok,
 %AHT20.Measurement{
   humidity_rh: 15.079402923583984,
   temperature_c: 28.26671600341797,
   temperature_f: 82.88008880615234
 }}
```

Depending on your hardware configuration, you may need to modify the call to
`AHT20.start_link/1`. See `t:AHT20.options/0` for parameters.
