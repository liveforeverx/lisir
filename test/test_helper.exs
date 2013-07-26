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
    spawn(fn -> Lisir.repl({[],[]}, "") end)
    |> Process.register(:test_repl)
  end

  @doc """
  Feeds the input to a running repl and returns the output.
  """
  def lisir(input) do
    :test_repl <- {self, {:input, input}}
    receive do
      :do_input -> ""
      {:output, e} when is_binary(e) -> e
      {:output, r} -> Enum.map_join(r, "\n", Lisir.pp(&1))
    end
  end
end
