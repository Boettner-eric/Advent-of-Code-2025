defmodule SecretEntranceTest do
  use ExUnit.Case

  @tag :sample
  test "day one, gets correct answer for part one with the sample input" do
    assert SecretEntrance.part_one(:sample) == 3
  end

  test "day one, gets correct answer for part one" do
    assert SecretEntrance.part_one(:input) == 1147
  end

  @tag :sample
  test "day one, gets correct answer for part two with the sample input" do
    assert SecretEntrance.part_two(:sample) == 6
  end

  test "day one, gets correct answer for part two" do
    assert SecretEntrance.part_two(:input) == 6789
  end
end
