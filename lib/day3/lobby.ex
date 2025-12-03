defmodule Lobby do
  # https://adventofcode.com/2025/day/3
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce(0, fn line, count ->
      numbers =
        String.split(line, "", trim: true)
        |> Enum.map(&String.to_integer/1)

      first_digit =
        Enum.slice(numbers, 0..-2//1)
        |> Enum.max()

      index = Enum.find_index(numbers, fn x -> x == first_digit end)

      second_digit =
        Enum.slice(numbers, (index + 1)..-1//1)
        |> Enum.max()

      first_digit * 10 + second_digit + count
    end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> IO.inspect()
  end
end
