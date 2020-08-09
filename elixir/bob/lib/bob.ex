defmodule Bob do
  import String
  def hey(input) do
    str = trim input
    cond do
      str == "" -> "Fine. Be that way!"
      ends_with?(str, "?") && yelling?(str) -> "Calm down, I know what I'm doing!"
      ends_with?(str, "?") -> "Sure."
      yelling?(str) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp yelling?(str) do
    str == upcase(str) && Regex.run(~r/[[:alpha:]]/, str) != nil
  end
end
