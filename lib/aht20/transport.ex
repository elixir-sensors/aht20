defmodule AHT20.Transport do
  @moduledoc false

  defstruct [:ref, :bus_address]

  @type t :: %__MODULE__{ref: reference(), bus_address: 0..127}
  @type option :: {:bus_name, String.t()} | {:bus_address, 0..127}

  @callback open([option()]) :: {:ok, t()} | {:error, any()}

  @callback read(t(), pos_integer()) :: {:ok, binary()} | {:error, any()}

  @callback write(t(), iodata()) :: :ok | {:error, any()}

  @callback write_read(t(), iodata(), pos_integer()) :: {:ok, binary()} | {:error, any()}
end

defmodule AHT20.Transport.I2C do
  @moduledoc false

  @behaviour AHT20.Transport

  @impl AHT20.Transport
  def open(opts) do
    bus_name = Access.fetch!(opts, :bus_name)
    bus_address = Access.fetch!(opts, :bus_address)

    case Circuits.I2C.open(bus_name) do
      {:ok, ref} ->
        {:ok, %AHT20.Transport{ref: ref, bus_address: bus_address}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl AHT20.Transport
  def read(transport, bytes_to_read) do
    Circuits.I2C.read(transport.ref, transport.bus_address, bytes_to_read)
  end

  @impl AHT20.Transport
  def write(transport, data) do
    Circuits.I2C.write(transport.ref, transport.bus_address, data)
  end

  @impl AHT20.Transport
  def write_read(transport, data, bytes_to_read) do
    Circuits.I2C.write_read(transport.ref, transport.bus_address, data, bytes_to_read)
  end
end

defmodule AHT20.Transport.Stub do
  @moduledoc false

  @behaviour AHT20.Transport

  @impl AHT20.Transport
  def open(_opts), do: {:ok, %AHT20.Transport{ref: make_ref(), bus_address: 0x00}}

  @impl AHT20.Transport
  def read(_transport, _bytes_to_read), do: {:ok, "stub"}

  @impl AHT20.Transport
  def write(_transport, _data), do: :ok

  @impl AHT20.Transport
  def write_read(_transport, _data, _bytes_to_read), do: {:ok, "stub"}
end
