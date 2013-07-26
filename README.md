# Lisir

[![Build Status](https://travis-ci.org/mrshankly/lisir.png)](https://travis-ci.org/mrshankly/lisir)

Lisir is a simple lisp interpreter based on [Peter Norvig's Lispy](http://norvig.com/lispy.html).

It currently supports the following forms: `quote`, `define`, `set!`, `if`, `lambda` and `begin`.
Some basic arithmetic and comparison operators are also available: `+`, `-`, `*`, `/`, `<`, `<=`,
`>`, `>=` and `=`.

Lisir does very little to detect and report errors.

## How to run

Install elixir, you can find how [here](http://elixir-lang.org/getting_started/1.html).

`$ git clone https://github.com/mrshankly/lisir`

`$ cd lisir`

`$ iex -S mix`

`iex(1)> Lisir.start`

## Example

![example](https://raw.github.com/mrshankly/lisir/master/img/example.png)

## License

All files under this repository fall under the MIT License (see the file LICENSE).
