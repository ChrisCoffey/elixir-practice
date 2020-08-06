defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    translate = fn c ->
      case c do
        71 ->
          'C'
        65 ->
          'U'
        67 ->
          'G'
        84 ->
          'A'
      end
    end

    Enum.concat(Enum.map(dna, translate))
  end
end
