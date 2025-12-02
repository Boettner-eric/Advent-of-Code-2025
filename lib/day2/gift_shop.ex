defmodule GiftShop do
  # https://adventofcode.com/2025/day/2
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn i, count ->
      [first, last] = String.split(i, "-", trim: true)

      Enum.to_list(String.to_integer(first)..String.to_integer(last))
      # remove all numbers with an odd number of digits
      |> Enum.filter(fn e -> rem(Integer.to_charlist(e) |> length, 2) == 0 end)
      |> Enum.reduce(0, &symmetric/2)
      |> Kernel.+(count)
    end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Enum.reduce(0, fn i, count ->
      [first, last] = String.split(i, "-", trim: true)

      Enum.to_list(String.to_integer(first)..String.to_integer(last))
      |> Enum.reduce(0, &symmetric_two/2)
      |> Kernel.+(count)
    end)
  end

  def symmetric(num, matches) do
    Integer.to_string(num)
    |> String.split_at(div(String.length(Integer.to_string(num)), 2))
    |> case do
      {a, a} -> num + matches
      _ -> matches
    end
  end

  def symmetric_two(number, matches) do
    num = Integer.to_string(number)
    size = String.length(num)

    Enum.reduce_while(2..size, matches, fn parts, count ->
      if size > 1 and rem(size, parts) == 0 and equal_parts(num, parts) == 1 do
        {:halt, number + count}
      else
        {:cont, count}
      end
    end)
  end

  def equal_parts(str, parts) do
    part_length = div(String.length(str), parts)

    Enum.reduce(0..(parts - 1), [], fn part, acc ->
      offset = part * part_length
      [String.slice(str, offset..(offset + part_length - 1)) | acc]
    end)
    |> MapSet.new()
    |> MapSet.size()
  end
end
