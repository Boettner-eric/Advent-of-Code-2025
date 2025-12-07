defmodule LaboratoriesTest do
  use ExUnit.Case

  @tag :sample
  test "day seven, gets correct answer for part one with the sample input" do
    assert Laboratories.part_one(:sample) == 21
  end

  test "day seven, gets correct answer for part one" do
    assert Laboratories.part_one(:input) == 1717
  end

  @tag :sample
  test "day seven, gets correct answer for part two with the sample input" do
    assert Laboratories.part_two(:sample) == 40
  end

  test "day seven, gets correct answer for part two" do
    assert Laboratories.part_two(:input) == 231_507_396_180_012
  end
end
