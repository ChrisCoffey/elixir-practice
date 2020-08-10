defmodule RobotSimulator do
  # point = tuple of X, Y
  defstruct pos: {0, 0}, direction: :north
  @valid_directions [:north, :south, :east, :west]

  @spec invalid_direction(d :: atom) :: bool
  def invalid_direction(d) do
    !Enum.member?(@valid_directions, d)
  end

  def invalid_position({a, b}) do
    !(is_integer(a) && is_integer(b))
  end
  def invalid_position p do
    true
  end

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    cond do
      invalid_direction(direction) -> {:error, "invalid direction"}
      invalid_position(position) -> {:error, "invalid position"}
      true -> %RobotSimulator{pos: position, direction: direction}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    if Regex.run(~r/[^LRA]/, instructions) != nil do
      {:error, "invalid instruction"}
    else
      turn_left = %{north: :west, west: :south, south: :east, east: :north}
      turn_right = %{north: :east, east: :south, south: :west, west: :north}
      advance = fn r ->
        {x,y} = r.pos
        case r.direction do
          :north -> %{r | pos: {x, y + 1}}
          :south -> %{r | pos: {x, y - 1}}
          :east -> %{r | pos: {x + 1, y}}
          :west -> %{r | pos: {x - 1, y}}
        end
      end

      instructions |>
      String.to_charlist |>
      Enum.reduce(robot, fn c, acc ->
        case c do
          ?A -> advance.(acc)
          ?L -> %{acc| direction: turn_left[acc.direction]}
          ?R -> %{acc| direction: turn_right[acc.direction]}
        end
      end
      )

    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.pos
  end
end
