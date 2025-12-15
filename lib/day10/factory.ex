defmodule Factory do
  # https://adventofcode.com/2025/day/10
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(0, fn {buttons, presses, _joltage}, c ->
      combo = Map.get(find_all_combos(presses), buttons)
      c + Enum.reduce(combo, 100_000, fn i, acc -> min(acc, length(i)) end)
    end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {_buttons, presses, joltage} ->
      find_all_combos(presses) |> fewest_button_presses(joltage)
    end)
    |> Enum.sum()
  end

  def parse_line(line) do
    data = String.split(line, " ", trim: true)

    buttons =
      Enum.at(data, 0)
      |> String.slice(1..-2//1)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {v, i}, acc ->
        if v == "#", do: MapSet.put(acc, i), else: acc
      end)

    presses =
      Enum.slice(data, 1..-2//1)
      |> Enum.map(fn j ->
        String.split(j, ["(", ")", ","], trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> MapSet.new()

    joltage =
      Enum.at(data, -1)
      |> String.split(["{", "}", ","], trim: true)
      |> Enum.map(&String.to_integer/1)

    {buttons, presses, joltage}
  end

  # I really struggled with this one and after giving up and seeing that most of the solutions
  # used python with linear algebra imports I put this on the shelf.
  # This comment popped up and I implemented its algorithm to finally solve this problem
  # https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/ in my free time

  def find_all_combos(presses) do
    press_list = MapSet.to_list(presses)

    Enum.reduce(0..MapSet.size(presses), %{}, fn size, acc ->
      Enum.reduce(combos(press_list, size), acc, fn combo, bcc ->
        Enum.reduce(combo, MapSet.new(), fn button, pattern_acc ->
          MapSet.symmetric_difference(pattern_acc, MapSet.new(button))
        end)
        |> then(&Map.update(bcc, &1, [combo], fn existing -> [combo | existing] end))
      end)
    end)
  end

  def combos(_presses, 0), do: [[]]
  def combos([], _number), do: []

  def combos([first | next], number) do
    Enum.map(combos(next, number - 1), fn combo -> [first | combo] end) ++ combos(next, number)
  end

  def fewest_button_presses(combos, joltage) do
    if Enum.all?(joltage, &(&1 == 0)) do
      0
    else
      indicators =
        Enum.reduce(Enum.with_index(joltage), MapSet.new(), fn {value, index}, acc ->
          if rem(value, 2) == 1, do: MapSet.put(acc, index), else: acc
        end)

      Enum.reduce(Map.get(combos, indicators, []), 1_000_000, fn combo, acc ->
        adjusted_joltage = adjust_joltage(combo, joltage)

        if Enum.any?(adjusted_joltage, &(&1 < 0)) do
          acc
        else
          case fewest_button_presses(combos, Enum.map(adjusted_joltage, &div(&1, 2))) do
            nil -> acc
            k -> min(length(combo) + 2 * k, acc)
          end
        end
      end)
    end
  end

  def adjust_joltage(combo, joltage) do
    Enum.reduce(combo, joltage, fn j, acc ->
      Enum.reduce(j, acc, fn k, bcc ->
        List.update_at(bcc, k, &(&1 - 1))
      end)
    end)
  end
end
