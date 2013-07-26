Code.require_file "test_helper.exs", __DIR__

defmodule LisirTest do
  use Lisir.Case

  start_lisir

  test "sum" do
    assert lisir("(+ 1 2)") == "3"
  end

  test "sum big" do
    assert lisir("(+ 1 2 3 4 5)") == "15"
  end

  test "division" do
    assert lisir("(/ 6 2 1)") == "3.0"
  end

  test "comparison" do
    assert lisir("(< 1 2 3)") == "#t"
  end

  test "equal" do
    assert lisir("(= 2 2 2)") == "#t"
  end

  test "define" do
    assert(lisir("(define x 1)") == "") &&
    assert(lisir("x") == "1")
  end

  test "set!" do
    assert(lisir("(set! x 2)") == "") &&
    assert(lisir("x") == "2")
  end

  test "if true" do
    assert lisir("(if (< 1 2) 1 2)") == "1"
  end

  test "if false" do
    assert lisir("(if (= 1 2) 1 2)") == "2"
  end

  test "quote" do
    assert lisir("(quote (+ 1 1))") == "(+ 1 1)"
  end

  test "simple begin" do
    assert lisir("(begin (+ 1 1))") == "2"
  end

  test "complex begin" do
    assert lisir("(begin (define y 1) (set! y 2) y)") == "2"
  end

  test "lambda" do
    assert lisir("((lambda (z) (+ z 1)) 2)") == "3"
  end

  test "define lambda" do
    assert(lisir("(define area (lambda (l w) (* l w)))") == "") &&
    assert(lisir("(area 3 5)") == "15")
  end

  test "multiple inputs per line" do
    assert(lisir("(* 2 2) (+ 8 8) (> 1 2)") == "4\n16\n#f")
  end

  test "multiline input" do
    assert(lisir("(define square") == "") &&
    assert(lisir("  (lambda (x) (* x x)))") == "") &&
    assert(lisir("(square 5)") == "25")
  end
end
