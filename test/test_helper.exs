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
	Starts an test repl, feeds it the provided input and returns the output.
	"""
	def lisir(input) do
		ExUnit.CaptureIO.capture_io([input: input, capture_prompt: false], fn ->
			Lisir.start end) |> strip_output
	end

	defp strip_output(s) do
		Regex.replace(%r/\A.+?$/ms, s, "")
		|> String.strip
	end
end
