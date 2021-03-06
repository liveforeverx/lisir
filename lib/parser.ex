defmodule Parser do
  @moduledoc """
  Contains the parser for lisir.
  """

  @doc """
  Turns the given expression into a list of tokens.
  eg.
  "(define x (* 2 3))" => ['(', 'define', 'x', '(', '*', '2', '3', ')', ')']
  """
  def tokenize(s) do
    tokenize(s, [], [])
  end

  def tokenize("", t_acc, acc) do
    unless t_acc === [] do
      Enum.reverse([Enum.reverse(t_acc) | acc])
    else
      Enum.reverse(acc)
    end
  end

  def tokenize(<<?(, r :: binary>>, t_acc, acc) do
    tokenize(r, t_acc, ['(' | acc])
  end

  def tokenize(<<?), r :: binary>>, t_acc, acc) do
    unless t_acc === [] do
      tokenize(r, [], [')', Enum.reverse(t_acc) | acc])
    else
      tokenize(r, [], [')' | acc])
    end
  end

  def tokenize(<<32, r :: binary>>, t_acc, acc) do
    unless t_acc === [] do
      tokenize(r, [], [Enum.reverse(t_acc) | acc])
    else
      tokenize(r, [], acc)
    end
  end

  def tokenize(<<c, r :: binary>>, t_acc, acc) do
    tokenize(r, [c | t_acc], acc)
  end

  @doc """
  Parses the given list of tokens into a list of trees to be evaluated.
  eg.
  "(define square (lambda (x) (* x x))) (* 2 2)"
  => [[:define, :square, [:lambda, [:x], [:*, :x, :x]]], [:*, 2, 2]]
  """
  def parse(l) do
    case l do
      [')'] -> raise %s/unexpected ")"/
      other -> parse(other, 0, [])
    end
  end

  defp parse([], 0, acc) do
    Enum.reverse(acc)
  end

  defp parse(['(' | r], count, acc) do
    {rem, tree} = do_inner(r, [])
    parse(rem, count, [tree | acc])
  end

  defp parse([')' | r], count, acc) do
    parse(r, count - 1, acc)
  end

  defp parse([t | r], count, acc) do
    parse(r, count, [atom(t) | acc])
  end

  defp do_inner([], _acc) do
    throw :incomplete
  end

  defp do_inner([')' | r], acc) do
    {r, Enum.reverse(acc)}
  end

  defp do_inner(['(' | r], acc) do
    {rem, tree} = do_inner(r, [])
    do_inner(rem, [tree | acc])
  end

  defp do_inner([t | r], acc) do
    do_inner(r, [atom(t) | acc])
  end

  # Numbers into numbers, anything else is an atom.
  defp atom(token) do
    case :string.to_float(token) do
      {num, []} ->
        num
      {:error, _} ->
        case :string.to_integer(token) do
          {num, []} ->
            num
          {:error, _} ->
            list_to_atom(token)
        end
    end
  end
end
