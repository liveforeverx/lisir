defmodule Eval do
	@moduledoc """
	Contains the evaluation functions used with lisir.
	"""

	@doc """
	Evaluates the given tree. Returns a 2 element tuple, the first element is
	the result, the second is the new enviroment.
	"""
	def eval([:+  | l], e), do: {Lib.ladd(get_bindings(l, e)), e}
	def eval([:-  | l], e), do: {Lib.lsub(get_bindings(l, e)), e}
	def eval([:*  | l], e), do: {Lib.lmul(get_bindings(l, e)), e}
	def eval([:/  | l], e), do: {Lib.ldiv(get_bindings(l, e)), e}
	def eval([:=  | l], e), do: {Lib.equal(get_bindings(l, e)), e}
	def eval([:>  | l], e), do: {Lib.gt(get_bindings(l, e)), e}
	def eval([:<  | l], e), do: {Lib.lt(get_bindings(l, e)), e}
	def eval([:>= | l], e), do: {Lib.ge(get_bindings(l, e)), e}
	def eval([:<= | l], e), do: {Lib.le(get_bindings(l, e)), e}

	def eval([:quote, exp], env), do: {exp, env}

	def eval([:define, var, exp], env) do
		{r, _} = eval(exp, env)
		{nil, env_put(env, var, r)}
	end

	def eval([:set!, var, exp], env)do
		env_get!(env, var)
		{r, _} = eval(exp, env)
		{nil, env_put(env, var, r)}
	end

	def eval([:if, test, ts, fs], env) do
		case eval(test, env) do
			{true, _}  -> eval(ts, env)
			{false, _} -> eval(fs, env)
		end
	end

	# Creates an elixir anonymous function that will evaluate `exps`. A new
	# enviroment is created with the existing `env` as a parent.
	def eval([:lambda, args, exps], env) do
		{fn(params) -> eval(exps, new_env(args, params, env)) end, env}
	end

	def eval([:begin, exp], env) do
		eval(exp, env)
	end

	def eval([:begin, exp | rest], env) do
		{_, e} = eval(exp, env)
		eval([:begin | rest], e)
	end

	def eval(exps, env) when is_list(exps) do
		[{fun, _} | params] = Enum.map(exps, fn(exp) -> eval(exp, env) end)
		params = Enum.map(params, fn({p,_}) -> p end)
		if is_function(fun) do
			fun.(params)
		else
			raise "#{fun} is not a procedure"
		end
	end

	def eval(a, env) when is_atom(a), do: {env_get!(env, a), env}
	def eval(other, env), do: {other, env}

	# Replace variables with their repective values
	defp get_bindings(l, e) do
		Enum.reduce(l, [], fn
		                     x, acc when is_atom(x) -> [env_get!(e, x) | acc]
		                     x, acc -> [x | acc]
		                   end)
		|> Enum.reverse
	end

	# Create a new enviroment, used on lambdas, an optional parent can be given
	# as an argument.
	defp new_env(keys, vals, parent) when is_list(keys) do
		kl = length(keys)
		vl = length(vals)
		if kl === vl do
			{Enum.zip(keys, vals), parent}
		else
			raise "expecting #{kl} arguments, got #{vl}"
		end
	end

	defp new_env(key, val, parent) when is_atom(key) do
		vl = length(val)
		if vl === 1 do
			{[{key, hd(val)}], parent}
		else
			raise "expecting 1 argument, got #{vl}"
		end
	end

	# Get the value of key `k` in the enviroment, if the nothing is found
	# an exception is raised.
	defp env_get!({e, p}, k) do
		case e[k] do
			nil ->
				case p do
					[] -> raise %b/#{k} undefined/
					_  -> env_get!(p, k)
				end
			val ->
				val
		end
	end

	# Create a copy of enviroment `e` with a new pair `k: v`.
	defp env_put({e, p}, k, v) do
		{Keyword.put(e, k, v), p}
	end
end
