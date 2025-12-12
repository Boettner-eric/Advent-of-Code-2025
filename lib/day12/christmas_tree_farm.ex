defmodule ChristmasTreeFarm do
  # https://adventofcode.com/2025/day/12
  def part_one(input) do
    blob =
      AdventOfCode.read_blob(__DIR__, input)
      |> String.split("\n\n", trim: true)

    presents = Enum.slice(blob, 0..-1//1) |> parse_presents()
    trees = Enum.at(blob, -1) |> parse_tree()
    Enum.count(trees, &check_region(&1, presents))
  end

  def part_two(_input) do
    nil
  end

  def parse_presents(lines) do
    Enum.reduce(lines, %{}, fn line, map ->
      [index | present] = String.split(line, "\n", trim: true)
      Map.put(map, String.at(index, 0), present)
    end)
  end

  def parse_tree(blob) do
    String.split(blob, "\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      [size | indexes] = String.split(line, " ", trim: true)
      [x, y] = String.split(size, ["x", ":"], trim: true) |> Enum.map(&String.to_integer/1)
      [{{x, y}, Enum.map(indexes, &String.to_integer/1)} | acc]
    end)
  end

  def check_region({{x, y}, p}, _presents) do
    x * y >= Enum.sum(p) * 9
  end
end
