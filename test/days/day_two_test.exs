defmodule GiftShopTest do
  use ExUnit.Case

  @tag :sample
  test "day two, gets correct answer for part one (sample)" do
    assert GiftShop.part_one("lib/day2/sample.txt") == 1_227_775_554
  end

  test "day two, gets correct answer for part one" do
    assert GiftShop.part_one() == 31_839_939_622
  end

  @tag :sample
  test "day two, gets correct answer for part two (sample)" do
    assert GiftShop.part_two("lib/day2/sample.txt") == 4_174_379_265
  end

  test "day two, gets correct answer for part two" do
    assert GiftShop.part_two() == 41_662_374_059
  end
end
