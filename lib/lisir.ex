defmodule Lisir do
	def start do
		IO.puts("Lisir - simple lisp interpreter (0.0.1) - type :q to exit")
		pid = spawn(fn -> input_loop end)
		wait_input(pid, {[],[]}, 1)
	end

	defp wait_input(input_pid, env, counter) do
		input_pid <- {self, :do_input, counter}
		receive do
			{:input, line} ->
				try do
					tree = case Parser.parse(String.rstrip(line, ?\n)) do
						{"", tree} ->
							tree
						{_rem, tree} ->
							# TODO
							tree
					end
					case Eval.eval(tree, env) do
						{nil, new_env} ->
							wait_input(input_pid, new_env, counter + 1)
						{res, new_env} ->
							IO.puts "#{pp(res)}"
							wait_input(input_pid, new_env, counter + 1)
					end
				rescue
					exception ->
						IO.puts "** #{exception.message}"
						wait_input(input_pid, env, counter)
				end
			:exit ->
				:ok
		end
	end

	defp input_loop do
		receive do
			{from, :do_input, counter} ->
				case IO.gets(:stdio, "lisir(#{counter})> ") do
					":q\n" ->
						from <- :exit
					:eof ->
						from <- :exit
					{:error, _} ->
						from <- :exit
					data ->
						from <- {:input, data}
						input_loop
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
