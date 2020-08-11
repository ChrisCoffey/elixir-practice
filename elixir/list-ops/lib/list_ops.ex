defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([]) do 0 end
  def count([h | t]) do
    1 + count(t)
  end

  @spec map(list, (any -> any)) :: list
  def map([], _) do [] end
  def map([h | tail], f) do
    [f.(h) | map(tail, f)]
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], f) do [] end
  def filter([h | tail], f) do
    if f.(h) do
      [h | filter(tail, f)]
    else
      filter(tail, f)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _) do acc end
  def reduce([x | xs], acc, f) do
    reduce(xs, f.(x, acc), f)
  end

  @spec reverse(list) :: list
  def reverse(xs) do
    reduce(xs, [], &([&1 | &2]))
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _) do acc end
  def foldr([x | xs], acc, f) do
    f.(x, foldr(xs, acc, f))
  end

  @spec append(list, list) :: list
  def append(a, b) do
    foldr(a, b, &([&1 | &2]))
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    foldr(ll, [], &(append(&1, &2)))
  end
end
