defmodule Parser do
	@moduledoc """
	Contains the parser for lisir.
	"""

	@doc """
	Parses the given source code into a list of numbers and atoms ready to be
	evaluated.
	eg.
	"(define square (lambda (x) (* x x)))"
	=> [:define, :square, [:lambda, [:x], [:*, :x, :x]]]
	"""
	def parse(<<?(, r :: binary>>) do
		do_parse(r, [], [])
	end

	def parse(<<?), _ :: binary>>) do
		raise %b/unexpected ")"/
	end

	def parse(s) do
		{"", atom(binary_to_list(s))}
	end

	defp do_parse(<<>>, _, _) do
		raise %b/missing terminator ")"/
	end

	defp do_parse(<<?), r :: binary>>, t_acc, l_acc) do
		{r, Enum.reverse(join(t_acc, l_acc))}
	end

	defp do_parse(<<?(, r :: binary>>, t_acc, l_acc) do
		new = join(t_acc, l_acc)
		{rem, lst} = do_parse(r, [], [])
		do_parse(rem, [], [lst | new])
	end

	defp do_parse(<<? , r :: binary>>, t_acc, l_acc) do
		do_parse(r, [], join(t_acc, l_acc))
	end

	defp do_parse(<<c, r :: binary>>, t_acc, l_acc) do
		do_parse(r, [c | t_acc], l_acc)
	end

	defp join([], lst), do: lst
	defp join(tokens, lst), do: [atom(Enum.reverse(tokens)) | lst]

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
