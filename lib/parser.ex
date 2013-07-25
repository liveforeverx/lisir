defmodule Parser do
	def parse(<<?(, r :: binary>>) do
		do_parse(r, [], [])
	end

	def parse(<<?), _ :: binary>>) do
		{:error, %b/unexpected ")"/}
	end

	def parse(s) when is_binary(s) do
		{:ok, "", atom(binary_to_list(s))}
	end

	def parse(s) do
		{:ok, "", s}
	end

	defp do_parse(<<>>, _, _) do
		{:error, %b/missing terminator ")"/}
	end

	defp do_parse(<<?), r :: binary>>, t_acc, l_acc) do
		{:ok, r, Enum.reverse(join(t_acc, l_acc))}
	end

	defp do_parse(<<?(, r :: binary>>, t_acc, l_acc) do
		new = join(t_acc, l_acc)
		case do_parse(r, [], []) do
			{:ok, rem, lst} ->
				do_parse(rem, [], [lst | new])
			{:error, reason} ->
				{:error, reason}
		end
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
