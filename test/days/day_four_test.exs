defmodule PrintingDepartmentTest do
  use ExUnit.Case

  @tag :sample
  test "day four, gets correct answer for part one with the sample input" do
    assert PrintingDepartment.part_one(:sample) == 13
  end

  test "day four, gets correct answer for part one" do
    assert PrintingDepartment.part_one(:input) == 1537
  end

  @tag :sample
  test "day four, gets correct answer for part two with the sample input" do
    assert PrintingDepartment.part_two(:sample) == 43
  end

  test "day four, gets correct answer for part two" do
    assert PrintingDepartment.part_two(:input) == 8707
  end
end
