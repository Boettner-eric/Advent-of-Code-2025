defmodule Cafeteria do
  # https://adventofcode.com/2025/day/5
  def part_one(input) do
    AdventOfCode.read_blob(__DIR__, input)
    |> parse_input()
    |> lookup_ingredients()
  end

  def part_two(input) do
    AdventOfCode.read_blob(__DIR__, input)
    |> parse_input()
    |> elem(0)
    |> expand_ranges()
    |> count_ranges()
  end

  def parse_input(blob) do
    [ranges, ingredients] = String.split(blob, "\n\n", trim: true)
    ingredients = String.split(ingredients, "\n", trim: true) |> Enum.map(&String.to_integer/1)

    {parse_range(ranges), ingredients}
  end

  def parse_range(range) do
    Enum.map(String.split(range, "\n"), fn a ->
      String.split(a, "-") |> Enum.map(&String.to_integer/1) |> then(fn [i, j] -> i..j end)
    end)
  end

  def lookup_ingredients({ranges, ingredients}) do
    Enum.reduce(ingredients, 0, fn ind, acc ->
      if Enum.any?(ranges, fn r -> ind in r end), do: acc + 1, else: acc
    end)
  end

  def expand_ranges(ranges) when is_list(ranges), do: expand_ranges({ranges, MapSet.new(ranges)})
  def expand_ranges({[], ranges}), do: ranges

  def expand_ranges({[range | queue], ranges}) do
    Enum.reduce(ranges, {queue, MapSet.new()}, fn i..j//_, {q, a} ->
      combine_range(range, i..j, a, q)
    end)
    |> expand_ranges()
  end

  def combine_range(x1..x2//_, y1..y2//_, a, q) do
    cond do
      x1..x2 == y1..y2 ->
        {q, MapSet.put(a, x1..x2)}

      x1 <= y2 and y1 <= x2 ->
        {q ++ [min(x1, y1)..max(x2, y2)], MapSet.put(a, min(x1, y1)..max(x2, y2))}

      true ->
        {q, MapSet.put(a, y1..y2) |> MapSet.put(x1..x2)}
    end
  end

  def count_ranges(ranges) do
    Enum.reduce(ranges, 0, fn r, acc ->
      Range.size(r) + acc
    end)
  end
end
