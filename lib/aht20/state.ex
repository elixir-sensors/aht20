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

      iex> AHT20.State.from_byte(0b0001_1100)
      %AHT20.State{busy: false, calibrated: true, mode: :nor}
  """
  @spec from_byte(byte) :: %{busy: boolean, calibrated: boolean, mode: :cmd | :cyc | :nor}
  def from_byte(state_byte) do
    <<busy::1, mode::2, _::1, cal::1, _::3>> = <<state_byte>>

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
