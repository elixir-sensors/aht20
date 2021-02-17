defmodule AHT20.State do
  @moduledoc """
  Represents the sensor state.
  """

  defstruct [:busy, :mode, :calibrated]

  @type t :: %__MODULE__{
          busy: boolean,
          mode: :cmd | :cyc | :nor,
          calibrated: boolean
        }

  @doc """
  Parses the sensor state byte into a human-readable struct.

      iex> AHT20.State.from_sensor_output(<<0b00011100>>)
      %AHT20.State{busy: false, calibrated: true, mode: :nor}
  """
  @spec from_sensor_output(<<_::8>>) :: t
  def from_sensor_output(<<busy::1, mode::2, _::1, cal::1, _::3>>) do
    __struct__(
      busy: busy == 1,
      mode:
        case mode do
          0 -> :nor
          1 -> :cyc
          _ -> :cmd
        end,
      calibrated: cal == 1
    )
  end
end
