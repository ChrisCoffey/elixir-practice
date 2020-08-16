defmodule Zipper do

  # The path is a stack of steps taken to traverse to the current node.
  # Each step contains a pointer to the parent tree at that point, and the direction
  # taken __from__ the parent to the current focus
  @type t :: %Zipper{focus: BinTree.t(), path: [any]}

  defstruct focus: nil, path: []

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{path: [], focus: bin_tree}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(zipper) do
    case zipper.path do
      [] -> zipper.focus
      _ -> to_tree(up(zipper))
    end
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper) do
    cond do
      zipper.focus.left ->
        %Zipper{path: [{:left, zipper.focus} | zipper.path], focus: zipper.focus.left}
      true -> nil
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper) do
    cond do
      zipper.focus.right ->
        %Zipper{path: [{:right, zipper.focus} | zipper.path], focus: zipper.focus.right}
      true ->
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(zipper) do
    case zipper.path do
      [] -> nil
      [{:left, parent} | rest ] ->
        %Zipper{path: rest, focus: parent} |> set_left(zipper.focus)
      [{:right, parent} | rest ] ->
        %Zipper{path: rest, focus: parent} |> set_right(zipper.focus)
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    b = %BinTree{zipper.focus | value: value}
    %Zipper{zipper | focus: b}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %Zipper{zipper | focus: %BinTree{zipper.focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %Zipper{zipper | focus: %BinTree{zipper.focus | right: right}}
  end
end
