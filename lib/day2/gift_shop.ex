defmodule GiftShop do
  # https://adventofcode.com/2025/day/2
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Task.async_stream(fn i ->
      [first, last] = String.split(i, "-", trim: true)

      String.to_integer(first)..String.to_integer(last)
      |> Enum.reduce(0, &symmetric/2)
    end)
    |> Enum.reduce(0, fn {:ok, c}, count -> c + count end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.at(0)
    |> String.split(",", trim: true)
    |> Task.async_stream(fn i ->
      [first, last] = String.split(i, "-", trim: true)

      String.to_integer(first)..String.to_integer(last)
      |> Enum.reduce(0, &symmetric_two/2)
    end)
    |> Enum.reduce(0, fn {:ok, c}, count -> c + count end)
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
    size = byte_size(num)

    Enum.reduce_while(size..2//-1, matches, fn parts, count ->
      if rem(size, parts) == 0 and equal_parts(num, div(size, parts)) do
        {:halt, count + number}
      else
        {:cont, count}
      end
    end)
  end

  defp equal_parts(str, size, pattern \\ nil)
  defp equal_parts(<<>>, _size, _pattern), do: true

  defp equal_parts(str, size, nil) do
    <<part::binary-size(size), rest::binary>> = str

    equal_parts(rest, size, part)
  end

  defp equal_parts(str, size, pattern) when byte_size(str) >= size do
    <<part::binary-size(size), rest::binary>> = str

    part == pattern and equal_parts(rest, size, part)
  end
end
