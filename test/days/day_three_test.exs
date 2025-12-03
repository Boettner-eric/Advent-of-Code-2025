defmodule LobbyTest do
  use ExUnit.Case

  @tag :sample
  test "day three, gets correct answer for part one with the sample input" do
    assert Lobby.part_one(:sample) == 357
  end

  test "day three, gets correct answer for part one" do
    assert Lobby.part_one(:input) == 17346
  end

  # @tag :sample
  # test "day three, gets correct answer for part two with the sample input" do
  #   assert Lobby.part_two(:sample) == nil
  # end

  # test "day three, gets correct answer for part two" do
  #   assert Lobby.part_two(:input) == nil
  # end
end
