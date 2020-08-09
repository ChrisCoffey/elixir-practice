defmodule RomanNumerals do
  @conversionTable %{
      1000 => "M",
      900 => "CM",
      500 => "D",
      400 => "CD",
      100 => "C",
      90 => "XC",
      50 => "L",
      40 => "XL",
      10 => "X",
      9 => "IX",
      5 => "V",
      4 => "IV",
      1 => "I"
      }

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    res = List.foldl(Enum.reverse(Map.keys(@conversionTable)), {"", number}, fn elem, {acc, n} ->
      counts = div(n, elem)
      leftover = rem(n, elem)

      if counts > 0 do
        newChars = Enum.reduce(List.duplicate(@conversionTable[elem], counts), fn l, r -> l <> r end)

        {acc<>newChars, leftover}
      else
        {acc, leftover}
      end
    end
    )
    elem(res, 0)
  end
end
