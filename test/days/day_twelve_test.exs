defmodule ChristmasTreeFarmTest do
  use ExUnit.Case

  test "day twelve, gets correct answer for part one" do
    assert ChristmasTreeFarm.part_one(:input) == 575
  end

  @tag :sample
  test "day twelve, gets correct answer for part two with the sample input" do
    assert ChristmasTreeFarm.part_two(:sample) == nil
  end

  test "day twelve, gets correct answer for part two" do
    assert ChristmasTreeFarm.part_two(:input) == nil
  end
end
