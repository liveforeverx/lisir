defmodule Lisir do
  def start do
    IO.puts("Lisir - simple lisp interpreter (0.0.1) - type :q to exit")
    pid = spawn(fn -> repl end)
    io(pid, 1)
  end

  def repl(env // {[],[]}) do
    receive do
      {from, {:input, line, counter}} ->
        try do
          {r, new_env} = Parser.tokenize(line)
          |> Parser.parse
          |> Enum.map_reduce(env, Eval.eval(&1, &2))

          from <- {:output, r, counter + 1}
          repl(new_env)
        rescue
          exception ->
            from <- {:output, "** #{exception.message}", counter}
            repl(env)
        end
      :exit ->
        :ok
    end
  end

  defp io(repl_pid, counter) do
    case IO.gets(:stdio, "lisir(#{counter})> ") do
      ":q\n" ->
        repl_pid <- :exit
      :eof ->
        repl_pid <- :exit
      {:error, _} ->
        repl_pid <- :exit
      data ->
        repl_pid <- {self, {:input, String.rstrip(data, ?\n), counter}}
        receive do
          {:output, e, ^counter} -> IO.puts(e)
          {:output, r, counter} ->
            Enum.each(r, fn
                           x when x !== nil -> IO.puts("#{pp x}")
                           _ -> :ok
                         end)
        end
        io(repl_pid, counter)
    end
  end

  @doc """
  Convert a elixir term into a lisp readable string.
  eg.
  [:define, :square, [:lambda, [:x], [:*, :x, :x]]]
  => "(define square (lambda (x) (* x x)))"
  """
  def pp(terms) when is_list(terms) do
    s = Enum.reduce(terms, "", fn
        term, "" when is_list(term) -> pp(term)
        term, ""  -> pp(term)
        term, acc when is_list(term) -> acc <> " " <> pp(term)
        term, acc -> acc <> " " <> pp(term)
      end)
    "(" <> s <> ")"
  end

  def pp(terms) do
    case terms do
      true  -> "#t"
      false -> "#f"
      other -> to_binary(other)
    end
  end
end
