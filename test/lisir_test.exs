Code.require_file "test_helper.exs", __DIR__

defmodule LisirTest do
  use Lisir.Case

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
    assert lisir("(< 1 2 3)") == "true"
  end

  test "equal" do
    assert lisir("(= 2 2 2)") == "true"
  end

  test "simple begin" do
    assert lisir("(begin (+ 1 1))") == "2"
  end

  test "define" do
    assert lisir("(begin (define x 1) x)") == "1"
  end

  test "set!" do
    assert lisir("(begin (define x 1) (set! x 2) x)") == "2"
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


  test "lambda" do
    assert lisir("((lambda (x) (+ x 1)) 2)") == "3"
  end

  test "define lambda" do
    assert lisir("(begin (define square (lambda (x) (* x x))) (square 5))") == "25"
  end
end
