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

  def symmetric_two(num, matches) do
    num = Integer.to_string(num)

    Enum.reduce_while(1..String.length(num), matches, fn parts, count ->
      sub_sequence = split_string(num, parts)

      if length(sub_sequence) > 1 do
        case MapSet.size(MapSet.new(sub_sequence)) do
          1 -> {:halt, String.to_integer(num) + count}
          _ -> {:cont, count}
        end
      else
        {:cont, count}
      end
    end)
  end

  def split_string(str, parts) do
    String.codepoints(str)
    |> Enum.chunk_every(parts)
    |> Enum.map(&Enum.join/1)
  end
end
