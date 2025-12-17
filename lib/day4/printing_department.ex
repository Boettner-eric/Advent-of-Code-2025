defmodule PrintingDepartment do
  # https://adventofcode.com/2025/day/4
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> parse_lines()
    |> find_tp()
    |> length()
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> parse_lines()
    |> loop(0, [])
  end

  def parse_lines(lines) do
    Enum.reduce(Enum.with_index(lines), %{}, fn {line, y}, acc ->
      String.split(line, "")
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x}, map ->
        Map.put(map, {x, y}, val)
      end)
    end)
  end

  def loop(graph, 0, []), do: loop(graph, 0, find_tp(graph))
  def loop(_graph, tp, []), do: tp

  def loop(graph, tp, points) do
    graph = remove_points(graph, points)
    loop(graph, tp + length(points), find_tp(graph))
  end

  def find_tp(graph) do
    Enum.reduce(graph, [], fn {{x, y}, val}, tp ->
      if val == "@", do: adjacent_tp(graph, x, y) ++ tp, else: tp
    end)
  end

  def adjacent_tp(graph, i, j) do
    [
      {i, j - 1},
      {i, j + 1},
      {i - 1, j},
      {i - 1, j - 1},
      {i - 1, j + 1},
      {i + 1, j - 1},
      {i + 1, j + 1},
      {i + 1, j}
    ]
    |> Enum.count(fn {x, y} ->
      Map.get(graph, {x, y}) == "@"
    end)
    |> case do
      k when k < 4 -> [{i, j}]
      _ -> []
    end
  end

  def remove_points(graph, points) do
    Enum.reduce(points, graph, fn {x, y}, g ->
      Map.put(g, {x, y}, ".")
    end)
  end
end
