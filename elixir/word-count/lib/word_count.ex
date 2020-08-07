defmodule WordCount do
  import Enum
  import String

  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    cleaned = sentence |>
    downcase |>
    replace(~r/[:!@#$%^&,.]/, " ") |>
    replace("_", " ") |>
    split


    cleaned |>
      group_by(fn x -> x end) |>
      map(fn {k, v} -> { k, Kernel.length(v) } end) |>
      into(%{})
  end
end
