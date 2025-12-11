defmodule ReactorTest do
  use ExUnit.Case

  @tag :sample
  test "day eleven, gets correct answer for part one with the sample input" do
    assert Reactor.part_one(:sample) == 5
  end

  test "day eleven, gets correct answer for part one" do
    assert Reactor.part_one(:input) == 599
  end

  @tag :sample
  test "day eleven, gets correct answer for part two with the sample input" do
    assert Reactor.part_two("sample2.txt") == 2
  end

  test "day eleven, gets correct answer for part two" do
    assert Reactor.part_two(:input) == 393_474_305_030_400
  end
end
