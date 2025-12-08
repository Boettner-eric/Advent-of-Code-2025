defmodule PlaygroundTest do
  use ExUnit.Case

  @tag :sample
  test "day eight, gets correct answer for part one with the sample input" do
    assert Playground.part_one(:sample) == 40
  end

  test "day eight, gets correct answer for part one" do
    assert Playground.part_one(:input, 1000) == 117_000
  end

  @tag :sample
  test "day eight, gets correct answer for part two with the sample input" do
    assert Playground.part_two(:sample) == 25272
  end

  test "day eight, gets correct answer for part two" do
    assert Playground.part_two(:input) == 8_368_033_065
  end
end
