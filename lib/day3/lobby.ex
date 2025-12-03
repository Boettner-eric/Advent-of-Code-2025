defmodule Lobby do
  # https://adventofcode.com/2025/day/3
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce(0, fn line, count ->
      numbers =
        String.split(line, "", trim: true)
        |> Enum.map(&String.to_integer/1)

      {first_digit, index} = next_digit(numbers, 0, 2)
      {second_digit, _index} = next_digit(numbers, index, 1)

      first_digit * 10 + second_digit + count
    end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce(0, fn line, count ->
      numbers =
        String.split(line, "", trim: true)
        |> Enum.map(&String.to_integer/1)

      Enum.reduce(12..1//-1, {count, 0}, fn digit, {count, last} ->
        {new_digit, index} = next_digit(numbers, last, digit)
        {new_digit * :math.pow(10, digit - 1) + count, index}
      end)
      |> elem(0)
    end)
  end

  def next_digit(numbers, last, left) do
    slice = Enum.slice(numbers, last..-left//1)
    digit = Enum.max(slice)
    index = Enum.find_index(slice, &Kernel.==(&1, digit))

    {digit, last + index + 1}
  end
end
