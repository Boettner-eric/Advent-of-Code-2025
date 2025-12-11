defmodule Reactor do
  use Memoize
  # https://adventofcode.com/2025/day/11
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce(%{}, &parse_line/2)
    |> find_out("you")
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.reduce(%{}, &parse_line/2)
    # alternatively we can find the sub paths
    # from svr -> fft, fft -> dac, dac -> out
    # and svr -> dac, dac -> fft, fft -> out
    # but this is fine for now
    |> find_out("svr", ["fft", "dac"])
  end

  def parse_line(line, map) do
    [src | dest] = String.split(line, [":", " "], trim: true)
    Map.put(map, src, dest)
  end

  defmemo find_out(cables, current, targets \\ [], visited \\ %{}) do
    if cables[current] == ["out"] do
      if Enum.all?(targets, &Map.get(visited, &1, false)), do: 1, else: 0
    else
      visited = if current in targets, do: Map.put(visited, current, true), else: visited

      Enum.reduce(cables[current], 0, fn cable, acc ->
        acc + find_out(cables, cable, targets, visited)
      end)
    end
  end
end
