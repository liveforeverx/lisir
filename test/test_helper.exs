ExUnit.start

defmodule Lisir.Case do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use ExUnit.Case, async: false
      import unquote(__MODULE__)
    end
  end

  @doc """
  Starts a new process of a test repl.
  """
  def start_lisir do
    spawn(fn -> Lisir.repl end)
    |> Process.register(:test_repl)
  end

  @doc """
  Feeds the input to a running repl and returns the output.
  """
  def lisir(input) do
    :test_repl <- {self, {:input, input, 1}}
    receive do
      {:output, val, _} -> val
    end
  end
end
