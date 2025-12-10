defmodule MovieTheater do
  # https://adventofcode.com/2025/day/9
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.map(&parse_points/1)
    |> max_area()
    |> elem(0)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.map(&parse_points/1)
    |> max_area2()
    |> elem(0)
  end

  def parse_points(input) do
    String.split(input, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  def max_area(points) do
    Enum.reduce(points, {0, nil}, fn i, acc ->
      Enum.reduce(points, acc, fn j, {m, p} ->
        case area(i, j) do
          area when area > m -> {area, {i, j}}
          _ -> {m, p}
        end
      end)
    end)
  end

  def max_area2(points) do
    edges = get_edges(points)

    Enum.reduce(points, {0, nil}, fn i, acc ->
      Enum.reduce(points, acc, fn j, {m, p} ->
        area = area(i, j)

        cond do
          area > m and not intersects_any_edges?(edges, i, j) -> {area, {i, j}}
          true -> {m, p}
        end
      end)
    end)
  end

  def get_edges(points) do
    # take each pair of points and create an edge
    Enum.reduce(0..(length(points) - 1), [], fn i, acc ->
      {x1, y1} = Enum.at(points, i - 1)
      {x2, y2} = Enum.at(points, i)

      cond do
        x1 == x2 -> [{{x1, min(y1, y2)}, {x1, max(y1, y2)}}] ++ acc
        y1 == y2 -> [{{min(x1, x2), y1}, {max(x1, x2), y1}}] ++ acc
      end
    end)
  end

  def intersects_any_edges?(shape, {x1, y1}, {x2, y2}) do
    Enum.any?(shape, fn edge ->
      aabb_intersection?({{x1, y1}, {x2, y2}}, edge)
    end)
  end

  defp aabb_intersection?({{x1, y1}, {x2, y2}}, {{a1, b1}, {a2, b2}}) do
    max(x1, x2) > min(a1, a2) and
      max(a1, a2) > min(x1, x2) and
      max(y1, y2) > min(b1, b2) and
      max(b1, b2) > min(y1, y2)
  end

  def area({x, y}, {x1, y1}) do
    (abs(x - x1) + 1) * (abs(y - y1) + 1)
  end
end
