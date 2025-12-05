defmodule CafeteriaTest do
  use ExUnit.Case

  @tag :sample
  test "day five, gets correct answer for part one with the sample input" do
    assert Cafeteria.part_one(:sample) == 3
  end

  test "day five, gets correct answer for part one" do
    assert Cafeteria.part_one(:input) == 735
  end

  @tag :sample
  test "day five, gets correct answer for part two with the sample input" do
    assert Cafeteria.part_two(:sample) == 14
  end

  test "day five, gets correct answer for part two" do
    assert Cafeteria.part_two(:input) == 344_306_344_403_172
  end
end
