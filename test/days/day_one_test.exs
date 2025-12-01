defmodule SecretEntranceTest do
  use ExUnit.Case

  test "day one, gets correct answer for sample one" do
    assert SecretEntrance.problem_one("lib/day1/sample.txt") == 3
  end

  test "day one, gets correct answer for problem one" do
    assert SecretEntrance.problem_one() == 1147
  end

  test "day one, gets correct answer for sample two" do
    assert SecretEntrance.problem_two("lib/day1/sample.txt") == 6
  end

  test "day one, gets correct answer for problem two" do
    assert SecretEntrance.problem_two() == 6789
  end
end
