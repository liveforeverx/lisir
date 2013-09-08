defmodule Lisir do
  @moduledoc false

  @doc """
  Start lisir repl.
  """
  def start do
    IO.puts("Lisir (0.0.1) - type (q) to exit\n")
    pid = spawn(fn -> repl({[],[]}, "") end)
    io(pid, 1, "lir")
  end

  @doc """
  Receive loop for lisir repl.
  """
  def repl(env, cache) do
    receive do
      {from, {:input, code}} ->
        code = cache <> code
        try do
          {r, new_env} = Parser.tokenize(code)
          |> Parser.parse
          |> Enum.map_reduce(env, Eval.eval(&1, &2))

          from <- {:output, r}
          repl(new_env, "")

        catch
          :incomplete ->
            from <- :do_input
            repl(env, code <> " ")

        rescue
          exception ->
            from <- {:output, "** #{exception.message}"}
            repl(env, "")
        end

      :exit ->
        :ok
    end
  end

  defp io(repl_pid, counter, prefix) do
    case IO.gets(:stdio, prefix <> "(#{counter})> ") do
      "(q)\n" ->
        repl_pid <- :exit
      :eof ->
        repl_pid <- :exit
      {:error, _} ->
        repl_pid <- :exit
      data ->
        repl_pid <- {self, {:input, String.rstrip(data, ?\n)}}

        receive do
          :do_input ->
            io(repl_pid, counter, "...")

          {:output, e} when is_binary(e) ->
            IO.puts(e)
            io(repl_pid, counter, "lir")

          {:output, r} when is_list(r) ->
            Enum.each(r, fn
                           x when x !== nil -> IO.puts("#{pp x}")
                           _ -> :ok
                         end)
            io(repl_pid, counter + 1, "lir")
        end
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
      other -> to_string(other)
    end
  end
end
