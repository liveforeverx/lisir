# Lisir

Lisir is a simple lisp interpreter based on [Peter Norvig's Lispy](http://norvig.com/lispy.html).

It currently supports the following forms: `quote`, `define`, `set!`, `if`, `lambda` and `begin`.
Some basic arithmetic and comparison operators are also available: `+`, `-`, `*`, `/`, `<`, `<=`,
`>`, `>=` and `=`.

Lisir does very little to detect and report errors.

## How to run

Install elixir, you can find how [here](http://elixir-lang.org/getting_started/1.html).

```
git clone https://github.com/mrshankly/lisir
cd lisir
iex -S mix
```

## Example

```
Lisir - simple lisp interpreter (0.0.1) - type :q to exit
lisir(1)> (+ 1 2 3)
6
lisir(2)> (> 5 2)
true
lisir(3)> (define x 10)
lisir(4)> (* x 2)
20
lisir(5)> (define square (lambda (x) (* x x)))
lisir(6)> (square 5)
25
lisir(7)> (define area (lambda (l w) (* l w)))
lisir(8)> (area 3 5)
15
lisir(9)> ((lambda x (+ x 1)) 8)
9
lisir(10)> :q
:exit
```

## License

All files under this repository fall under the MIT License (see the file LICENSE).
