defmodule AHT20.Transport do
  @moduledoc false

  @type bus_name :: String.t()
  @type bus_address :: 0..127

  @callback open(bus_name) ::
              {:ok, reference} | {:error, any}

  @callback write(reference, bus_address, iodata) ::
              :ok | {:error, any}

  @callback read(reference, bus_address, integer) ::
              {:ok, binary} | {:error, any}

  @callback write_read(reference, bus_address, iodata, integer) ::
              {:ok, binary} | {:error, any}
end
