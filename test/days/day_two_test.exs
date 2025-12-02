defmodule GiftShopTest do
  use ExUnit.Case

  @tag :sample
  test "day two, gets correct answer for part one with the sample input" do
    assert GiftShop.part_one(:sample) == 1_227_775_554
  end

  test "day two, gets correct answer for part one" do
    assert GiftShop.part_one(:input) == 31_839_939_622
  end

  @tag :sample
  test "day two, gets correct answer for part two with the sample input" do
    assert GiftShop.part_two(:sample) == 4_174_379_265
  end

  test "day two, gets correct answer for part two" do
    assert GiftShop.part_two(:input) == 41_662_374_059
  end
end
