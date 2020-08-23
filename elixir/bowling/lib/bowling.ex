defmodule Bowling do
  @type frame :: %{num: integer, rolls: [integer]}

  defstruct current_frame: %{num: 1, rolls: []}, previous: []
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: [frame]
  def start do
    %Bowling{current_frame: %{num: 1, rolls: []}, previous: []}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(_, roll) when roll < 0 do err_not_enough_pins() end
  def roll(_, roll) when roll > 10 do err_too_many_pins() end
  def roll(game, roll) do
    frame = game.current_frame
    cond do
      frame.num == 10 ->
        case frame.rolls do
          []  -> %{game | current_frame: %{frame | rolls: [roll]}}
          [first] when first + roll > 10 -> err_too_many_pins()
          [first] -> %{game | current_frame: %{frame | rolls: [roll | first]}}
          [10, 10] -> %{game | current_frame: %{frame | rolls: [roll, 10, 10]}}
          [first, second] when first + second > 10 -> %{game | current_frame: %{frame | rolls: [roll, second, first]}}
          _  -> err_roll_game_over()
        end
      true ->
        case frame.rolls do
          [] ->
            %{game | current_frame: %{frame | rolls: [roll]}}
          [10] ->
            f_next = next_frame(frame)
            %{current_frame: %{f_next | rolls: [roll]}, previous: [frame | game.previous]}
          [first] -> %{current_frame: next_frame(frame), previous: [%{frame | rolls: [roll, first]} | game.previous]}
        end
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(game) do
    cond do
      !game_over(game) -> {:error, "Score cannot be taken until the end of the game"}
      true ->
        # Given an in-order list of frames,
        [game.current_frame | game.previous] |>
        List.reverse |>
        score_frames
    end
  end

  defp score_frames([]) do 0 end
  defp score_frames([f | rest]) do
    score_frame([f | rest]) + score_frames rest
  end

  defp score_frame([frame, n,  m | _]) do
    case frame.rolls do
      [10] ->
        case [n.rolls, m.rolls] do
          [[a, b], _] -> 10 + a + b
          [[10], [a | _]] -> 20 + a
        end
      [a, b] when a + b == 10 ->
        a + b + n.rolls.last
      xs -> Enum.sum xs
    end
  end
  defp score_frame([frame, n | []]) do
  end
  # this must be the final frame
  defp score_frame(frame | []) do
    frame.rolls |> Enum.sum
  end


  defp game_over(game) do
    case game.current_frame do
      %{num: 10, rolls: [a,b,c]} -> true
      %{num: 10, rolls: [a,b]} when a+b < 10 -> true
      _ -> false
    end
  end

  defp next_frame(frame) do
    %{num: frame.num + 1, rolls: []}
  end

  defp err_too_many_pins do
    {:error, "Pin cound exceeds pins on the lane"}
  end

  defp err_not_enough_pins do
    {:error, "Negative roll is invalid"}
  end

  defp err_roll_game_over do
    {:error, "Cannot roll after game is over"}
  end
end
