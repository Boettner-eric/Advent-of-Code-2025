defmodule GiftShop do
  # https://adventofcode.com/2025/day/2
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn i, count ->
      [first, last] = String.split(i, "-", trim: true)

      String.to_integer(first)..String.to_integer(last)
      |> Enum.to_list()
      |> Enum.reduce(count, &symmetric/2)
    end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn i, count ->
      [first, last] = String.split(i, "-", trim: true)

      String.to_integer(first)..String.to_integer(last)
      |> Enum.to_list()
      |> Enum.reduce(count, &symmetric_two/2)
    end)
  end

  def symmetric(number, matches) do
    num = Integer.to_string(number)

    case String.split_at(num, div(String.length(num), 2)) do
      {a, a} -> number + matches
      _ -> matches
    end
  end

  def symmetric_two(number, matches) do
    num = Integer.to_string(number)
    size = String.length(num)

    Enum.reduce_while(2..size, matches, fn parts, count ->
      if size > 1 and rem(size, parts) == 0 and equal_parts(num, parts) do
        {:halt, number + count}
      else
        {:cont, count}
      end
    end)
  end

  def equal_parts(str, parts) do
    part_length = div(String.length(str), parts)

    Enum.reduce_while(0..(parts - 1), nil, fn part, current ->
      offset = part * part_length
      slice = String.slice(str, offset..(offset + part_length - 1))

      cond do
        is_nil(current) -> {:cont, slice}
        current == slice -> {:cont, current}
        true -> {:halt, false}
      end
    end)
  end
end
