defmodule NameExample do
  def problem_one(filename \\ "lib/day2/input.txt") do
    AdventOfCode.read_lines(filename)
    |> IO.inspect()
  end

  def problem_two(filename \\ "lib/day2/input.txt") do
    AdventOfCode.read_lines(filename)
    |> IO.inspect()
  end
end
