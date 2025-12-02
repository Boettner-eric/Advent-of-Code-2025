defmodule SecretEntrance do
  # https://adventofcode.com/2025/day/1
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce({50, 0}, fn rotation, {position, zeros} ->
      rotation
      |> rotate(position)
      |> Integer.mod(100)
      |> add_result(zeros)
    end)
    |> elem(1)
  end

  def rotate("L" <> amount, position), do: position - String.to_integer(amount)
  def rotate("R" <> amount, position), do: position + String.to_integer(amount)

  def add_result(pos, zeros) do
    {pos, if(pos == 0, do: zeros + 1, else: zeros)}
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce({50, 0}, fn rotation, {position, visits} ->
      new_position = rotate(rotation, position)
      {Integer.mod(new_position, 100), count_visits(new_position, position, visits)}
    end)
    |> elem(1)
  end

  # when starting at zero only count future visits
  def count_visits(pos, 0, visits) when pos <= 0, do: visits + div(abs(pos), 100)
  # if you are not at zero then count the first visit as well as all of the future visits
  def count_visits(pos, _, visits) when pos <= 0, do: visits + div(abs(pos), 100) + 1
  def count_visits(pos, _, visits), do: visits + div(abs(pos), 100)
end
