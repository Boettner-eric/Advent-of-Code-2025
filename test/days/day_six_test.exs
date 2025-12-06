defmodule TrashCompactorTest do
  use ExUnit.Case

  @tag :sample
  test "day six, gets correct answer for part one with the sample input" do
    assert TrashCompactor.part_one(:sample) == 4_277_556
  end

  test "day six, gets correct answer for part one" do
    assert TrashCompactor.part_one(:input) == 8_108_520_669_952
  end

  @tag :sample
  test "day six, gets correct answer for part two with the sample input" do
    assert TrashCompactor.part_two(:sample) == 3_263_827
  end

  test "day six, gets correct answer for part two" do
    assert TrashCompactor.part_two(:input) == 11_708_563_470_209
  end
end
