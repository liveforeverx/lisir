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
          tree = case Parser.parse(String.rstrip(line, ?\n)) do
            {"", tree} ->
              tree
            {_rem, tree} ->
              tree
          end
          {result, new_env} = Eval.eval(tree, env)
          from <- {:output, pp(result), counter + 1}
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
        repl_pid <- {self, {:input, data, counter}}
        receive do
          {:output, "nil", counter} ->
            io(repl_pid, counter)
          {:output, val, counter} ->
            IO.puts "#{val}"
            io(repl_pid, counter)
        end
    end
  end

  # Convert a elixir term into a lisp readable string.
  # eg.
  # [:define, :square, [:lambda, [:x], [:*, :x, :x]]]
  # => "(define square (lambda (x) (* x x)))"
  defp pp(terms) when is_list(terms) do
    s = Enum.reduce(terms, "", fn
        term, "" when is_list(term) -> pp(term)
        term, ""  -> to_binary(term)
        term, acc when is_list(term) -> acc <> " " <> pp(term)
        term, acc -> acc <> " " <> to_binary(term)
      end)
    "(" <> s <> ")"
  end
  defp pp(terms), do: inspect(terms)
end
