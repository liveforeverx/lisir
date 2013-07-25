defmodule Lib do
  def ladd(l), do: ladd(l, 0)
  def ladd([], acc), do: acc
  def ladd([x|xs], acc), do: ladd(xs, acc + x)

  def lsub([x|xs]), do: lsub(xs, x)
  def lsub([], acc), do: acc
  def lsub([x|xs], acc), do: lsub(xs, acc - x)

  def lmul(l), do: lmul(l, 1)
  def lmul([], acc), do: acc
  def lmul([x|xs], acc), do: lmul(xs, acc * x)

  def ldiv([x|xs]), do: ldiv(xs, x)
  def ldiv([], acc), do: acc
  def ldiv([x|xs], acc), do: ldiv(xs, acc / x)

  def equal([x|xs]), do: Enum.all?(xs, fn(z) -> z === x end)

  def gt([x|xs]), do: gt(xs, x)
  def gt([x], acc), do: acc > x
  def gt([x|xs], acc) do
    if acc > x do
      gt(xs, x)
    else
      false
    end
  end

  def lt([x|xs]), do: lt(xs, x)
  def lt([x], acc), do: acc < x
  def lt([x|xs], acc) do
    if acc < x do
      lt(xs, x)
    else
      false
    end
  end

  def ge([x|xs]), do: ge(xs, x)
  def ge([x], acc), do: acc >= x
  def ge([x|xs], acc) do
    if acc >= x do
      ge(xs, x)
    else
      false
    end
  end

  def le([x|xs]), do: le(xs, x)
  def le([x], acc), do: acc <= x
  def le([x|xs], acc) do
    if acc <= x do
      le(xs, x)
    else
      false
    end
  end
end
