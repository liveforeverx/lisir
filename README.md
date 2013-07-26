# Lisir

[![Build Status](https://travis-ci.org/mrshankly/lisir.png)](https://travis-ci.org/mrshankly/lisir)

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
Lisir.start
```

## Example

```
Lisir - (0.0.1) - type (q) to exit
lir(1)> (+ 1 2 3)
6
lir(2)> (> 5 2) (- 5 2)
#t
3
lir(3)> (define x 10)
lir(4)> (* x 2)
20
lir(5)> (define square
...(5)>   (lambda (x) (* x x)))
lir(6)> (square 5)
25
lir(7)> (define area
...(7)>   (lambda (l w) (* l w)))
lir(8)> (area 3 5)
15
lir(9)> ((lambda x (+ x 1)) 8)
9
lir(10)> (q)
:exit
```

## License

All files under this repository fall under the MIT License (see the file LICENSE).
