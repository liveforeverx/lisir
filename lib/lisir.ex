defmodule Lisir do
	def start do
		IO.puts("Lisir - simple lisp interpreter (0.0.1) - type :q to exit")
		repl({[],[]})
	end

	defp repl(env) do
		case IO.gets("lisir> ") do
			":q\n" ->
				:ok
			line ->
				 tree = case Parser.parse(String.rstrip(line, ?\n)) do
					{"", tree} ->
						tree
					{_rem, tree} ->
						# TODO
						tree
				end

				case Eval.eval(tree, env) do
					{nil, new_env} ->
						repl(new_env)
					{res, new_env} ->
						IO.puts "#{pp(res)}"
						repl(new_env)
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
