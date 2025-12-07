defmodule Laboratories do
  # https://adventofcode.com/2025/day/7
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> count_beams()
  end

  def count_beams(lines, beams \\ MapSet.new(), count \\ 0)
  def count_beams([], _beams, count), do: count

  def count_beams([line | lines], beams, count) do
    String.split(line, "", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({beams, count}, fn l, {b, c} ->
      case l do
        {"S", i} -> {MapSet.put(b, i), c}
        {"^", i} -> split_beams(b, i, c)
        _ -> {b, c}
      end
    end)
    |> then(fn {beams, count} -> count_beams(lines, beams, count) end)
  end

  # use a set to track what beams we can be at for each line
  # increment the count if we split at i
  def split_beams(beams, i, c) do
    if MapSet.member?(beams, i) do
      {MapSet.delete(beams, i) |> MapSet.put(i - 1) |> MapSet.put(i + 1), c + 1}
    else
      {beams, c}
    end
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> count_timelines()
  end

  def count_timelines(lines, beams \\ %{})
  def count_timelines([], beams), do: Map.values(beams) |> Enum.reduce(0, &Kernel.+/2)

  def count_timelines([line | lines], beams) do
    String.split(line, "", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(beams, fn l, b ->
      case l do
        {"S", i} -> Map.put(b, i, 1)
        {"^", i} -> split_timelines(b, i)
        _ -> b
      end
    end)
    |> then(fn beams -> count_timelines(lines, beams) end)
  end

  # each index has a count of how many timelines can get there
  # if we split then add the current count to both splits and reset the count for i
  def split_timelines(beams, i) do
    if Map.has_key?(beams, i) do
      current = Map.get(beams, i)

      Map.put(beams, i, 0)
      |> Map.update(i - 1, current, &(&1 + current))
      |> Map.update(i + 1, current, &(&1 + current))
    else
      beams
    end
  end
end
