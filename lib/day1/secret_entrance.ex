defmodule SecretEntrance do
  # https://adventofcode.com/2025/day/1
  def problem_one(filename \\ "lib/day1/input.txt") do
    AdventOfCode.read_lines(filename)
    |> Enum.reduce({50, 0}, fn rotation, {position, zeros} ->
      case rotation do
        "L" <> amount -> position - String.to_integer(amount)
        "R" <> amount -> position + String.to_integer(amount)
      end
      |> Integer.mod(100)
      |> add_result(zeros)
    end)
    |> elem(1)
  end

  def add_result(pos, zeros) do
    {pos, if(pos == 0, do: zeros + 1, else: zeros)}
  end

  def problem_two(filename \\ "lib/day1/input.txt") do
    AdventOfCode.read_lines(filename)
    |> Enum.reduce({50, 0}, fn rotation, {position, visits} ->
      case rotation do
        "L" <> amount -> position - String.to_integer(amount)
        "R" <> amount -> position + String.to_integer(amount)
      end
      |> count_visits(position, visits)
    end)
    |> elem(1)
  end

  # when starting at zero only count future visits
  def count_visits(pos, 0, visits) when pos <= 0 do
    {Integer.mod(pos, 100), visits + div(abs(pos), 100)}
  end

  # if you are not at zero then count the first visit as well as all of the future visits
  def count_visits(pos, _, visits) when pos <= 0 do
    {Integer.mod(pos, 100), visits + div(abs(pos), 100) + 1}
  end

  def count_visits(pos, _, visits) do
    {Integer.mod(pos, 100), visits + div(pos, 100)}
  end
end
