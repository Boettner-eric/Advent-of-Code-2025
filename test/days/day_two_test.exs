defmodule NameExampleTest do
  use ExUnit.Case

  test "day two, gets correct answer for sample one" do
    assert NameExample.problem_one("lib/day2/sample.txt") == nil
  end

  test "day two, gets correct answer for problem one" do
    assert NameExample.problem_one() == nil
  end

  test "day two, gets correct answer for sample two" do
    assert NameExample.problem_two("lib/day2/sample.txt") == nil
  end

  test "day two, gets correct answer for problem two" do
    assert NameExample.problem_two() == nil
  end
end
