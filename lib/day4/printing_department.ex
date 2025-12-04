defmodule PrintingDepartment do
  # https://adventofcode.com/2025/day/4
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce([], fn line, acc ->
      acc ++ [String.split(line, "", trim: true)]
    end)
    |> find_tp()
    |> length()
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce([], fn line, acc ->
      acc ++ [String.split(line, "", trim: true)]
    end)
    |> loop(0, [])
  end

  def loop(graph, 0, []), do: loop(graph, 0, find_tp(graph))
  def loop(_graph, tp, []), do: tp

  def loop(graph, tp, points) do
    tp = tp + length(points)
    graph = remove_points(graph, points)
    loop(graph, tp, find_tp(graph))
  end

  def find_tp(graph) do
    Enum.reduce(0..(length(graph) - 1), [], fn y, tp ->
      row = Enum.at(graph, y, [])

      Enum.reduce(0..(length(row) - 1), tp, fn x, tps ->
        if Enum.at(row, x) == "@", do: adjacent_tp(graph, x, y) ++ tps, else: tps
      end)
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
    |> Enum.filter(fn {x, y} ->
      if y >= 0 and y <= length(graph) - 1 do
        row = Enum.at(graph, y, [])
        x >= 0 and x <= length(row) - 1 and Enum.at(row, x) == "@"
      end
    end)
    |> length()
    |> case do
      k when k < 4 -> [{i, j}]
      _ -> []
    end
  end

  def remove_points(graph, points) do
    Enum.reduce(points, graph, fn {x, y}, g ->
      List.update_at(g, y, fn row ->
        List.replace_at(row, x, ".")
      end)
    end)
  end
end
