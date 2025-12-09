defmodule MovieTheaterTest do
  use ExUnit.Case

  @tag :sample
  test "day nine, gets correct answer for part one with the sample input" do
    assert MovieTheater.part_one(:sample) == 50
  end

  test "day nine, gets correct answer for part one" do
    assert MovieTheater.part_one(:input) == 4_781_546_175
  end

  @tag :sample
  test "day nine, gets correct answer for part two with the sample input" do
    assert MovieTheater.part_two(:sample) == 24
  end

  test "day nine, gets correct answer for part two" do
    assert MovieTheater.part_two(:input) == 1_573_359_081
  end
end
