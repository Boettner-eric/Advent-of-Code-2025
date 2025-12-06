defmodule TrashCompactor do
  # https://adventofcode.com/2025/day/6
  def part_one(input) do
    [ops | nums] = AdventOfCode.read_lines(__DIR__, input) |> Enum.reverse()
    ops = String.split(ops, " ", trim: true)

    Enum.reduce(nums, Enum.map(0..(length(ops) - 1), fn _ -> 0 end), fn i, acc ->
      line = String.split(i, " ", trim: true) |> Enum.map(&String.to_integer/1)

      Enum.reduce(0..(length(line) - 1), acc, fn j, count ->
        val = Enum.at(line, j)

        case Enum.at(ops, j) do
          "*" -> List.update_at(count, j, fn c -> if c != 0, do: c * val, else: val end)
          "+" -> List.update_at(count, j, fn c -> c + val end)
        end
      end)
    end)
    |> Enum.reduce(0, fn i, acc -> i + acc end)
  end

  def part_two(input) do
    [ops | lines] = AdventOfCode.read_lines(__DIR__, input) |> Enum.reverse()
    width = String.length(Enum.at(lines, 0)) - 1

    # move one char at a time from right to left
    Enum.reduce(width..0//-1, {0, []}, fn index, {count, numbers} ->
      # skip empty columns
      if Enum.all?(lines, fn l -> String.at(l, index) == " " end) do
        {count, []}
      else
        num = merge_digits(lines, index)

        case String.at(ops, index) do
          "*" -> {count + Enum.reduce(numbers, 1, &Kernel.*/2) * num, []}
          "+" -> {count + Enum.reduce(numbers, 0, &Kernel.+/2) + num, []}
          _ -> {count, [num | numbers]}
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
