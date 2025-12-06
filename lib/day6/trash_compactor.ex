defmodule TrashCompactor do
  # https://adventofcode.com/2025/day/6
  def part_one(input) do
    [ops | lines] = AdventOfCode.read_lines(__DIR__, input) |> Enum.reverse()
    ops = String.split(ops, " ", trim: true)
    initial = Enum.map(0..(length(ops) - 1), fn _ -> 0 end)

    Enum.reduce(lines, initial, fn line, numbers ->
      line = String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1)

      Enum.reduce(0..(length(line) - 1), numbers, fn j, c ->
        v = Enum.at(line, j)

        case Enum.at(ops, j) do
          "*" -> List.update_at(c, j, fn c -> if c != 0, do: c * v, else: v end)
          "+" -> List.update_at(c, j, fn c -> c + v end)
        end
      end)
    end)
    |> Enum.reduce(0, fn i, numbers -> i + numbers end)
  end

  def part_two(input) do
    [ops | lines] = AdventOfCode.read_lines(__DIR__, input) |> Enum.reverse()
    width = String.length(ops) - 1

    # move one char at a time from right to left
    Enum.reduce(width..0//-1, {0, []}, fn index, {count, numbers} ->
      # skip empty columns
      if Enum.all?(lines, fn l -> String.at(l, index) == " " end) do
        {count, []}
      else
        numbers = [merge_digits(lines, index) | numbers]

        case String.at(ops, index) do
          "*" -> {count + Enum.reduce(numbers, 1, &Kernel.*/2), []}
          "+" -> {count + Enum.reduce(numbers, 0, &Kernel.+/2), []}
          _ -> {count, numbers}
        end
      end
    end)
    |> elem(0)
  end

  def merge_digits(lines, index) do
    Enum.reduce(0..(length(lines) - 1), "", fn line, bcc ->
      case String.at(Enum.at(lines, line), index) do
        " " -> bcc
        c -> c <> bcc
      end
    end)
    |> String.to_integer()
  end
end
