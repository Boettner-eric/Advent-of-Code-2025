defmodule FactoryTest do
  use ExUnit.Case

  @tag :sample
  test "day ten, gets correct answer for part one with the sample input" do
    assert Factory.part_one(:sample) == 7
  end

  test "day ten, gets correct answer for part one" do
    assert Factory.part_one(:input) == 385
  end

  # @tag :sample
  # test "day ten, gets correct answer for part two with the sample input" do
  #   assert Factory.part_two(:sample) == nil
  # end

  # test "day ten, gets correct answer for part two" do
  #   assert Factory.part_two(:input) == nil
  # end
end
