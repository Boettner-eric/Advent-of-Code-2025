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
    shape = get_shape(points)

    Enum.reduce(points, {0, nil}, fn i, acc ->
      Enum.reduce(points, acc, fn j, {m, p} ->
        area = area(i, j)

        cond do
          area > m and check_bounds?(shape, i, j) -> {area, {i, j}}
          true -> {m, p}
        end
      end)
    end)
  end

  def check_bounds?(shape, {x1, y1}, {x2, y2}) do
    left = min(x1, x2)
    right = max(x1, x2)
    bottom = min(y1, y2)
    top = max(y1, y2)

    not Enum.any?(shape, fn {x, y} ->
      left < x and x < right and bottom < y and y < top
    end)
  end

  def get_shape(points) do
    # take each pair of points and create the shape
    Enum.reduce(0..(length(points) - 1), points, fn i, acc ->
      {x1, y1} = Enum.at(points, i - 1)
      {x2, y2} = Enum.at(points, i)

      cond do
        x1 == x2 -> Enum.map(min(y1, y2)..max(y1, y2), fn y -> {x1, y} end) ++ acc
        y1 == y2 -> Enum.map(min(x1, x2)..max(x1, x2), fn x -> {x, y1} end) ++ acc
      end
    end)
  end

  def area({x, y}, {x1, y1}) do
    (abs(x - x1) + 1) * (abs(y - y1) + 1)
  end
end
