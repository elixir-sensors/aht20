# AHT20

[![Hex version](https://img.shields.io/hexpm/v/aht20.svg "Hex version")](https://hex.pm/packages/aht20)
[![API docs](https://img.shields.io/hexpm/v/aht20.svg?label=docs "API docs")](https://hexdocs.pm/aht20)
[![CI](https://github.com/elixir-sensors/aht20/actions/workflows/ci.yml/badge.svg)](https://github.com/elixir-sensors/aht20/actions/workflows/ci.yml)
[![REUSE status](https://api.reuse.software/badge/github.com/elixir-sensors/aht20)](https://api.reuse.software/info/github.com/elixir-sensors/aht20)

Read temperature and humidity from AHT20 sensor in Elixir.

## Usage

```elixir
# Connect to the sensor.
iex> {:ok, pid} = AHT20.start_link(bus_name: "i2c-1")
{:ok, #PID<0.1407.0>}

# Read the humidity and temperature from the sensor.
iex> AHT20.measure(pid)
{:ok,
 %AHT20.Measurement{
   dew_point_c: 15.486471933717919,
   humidity_rh: 42.671871185302734,
   temperature_c: 29.494285583496094,
   timestamp_ms: 79084
 }}
```

Depending on your hardware configuration, you may need to modify the call to
`AHT20.start_link/1`. See `t:AHT20.option/0` for parameters.
