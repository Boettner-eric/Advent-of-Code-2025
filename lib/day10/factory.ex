defmodule Factory do
  # https://adventofcode.com/2025/day/10
  def part_one(input) do
    AdventOfCode.read_lines(__DIR__, input)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(0, fn machine, c -> c + find_combo(machine) end)
  end

  def part_two(input) do
    AdventOfCode.read_lines(__DIR__, input)
  end

  def parse_line(line) do
    data = String.split(line, " ", trim: true)

    buttons =
      Enum.at(data, 0)
      |> String.slice(1..-2//1)
      |> String.graphemes()
      |> Enum.map(&(&1 == "#"))

    presses =
      Enum.slice(data, 1..-2//1)
      |> Enum.map(fn j ->
        String.split(j, ["(", ")", ","], trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    joltage =
      Enum.at(data, -1)
      |> String.split(["{", "}", ","], trim: true)
      |> Enum.map(&String.to_integer/1)

    {buttons, presses, joltage}
  end

  def find_combo({_, presses, _} = machine) do
    queue = PriorityQueue.new() |> PriorityQueue.put(0, Enum.map(presses, fn _ -> 0 end))
    find_combo(queue, machine)
  end

  def find_combo(queue, {buttons, presses, joltage}) do
    {{cost, combo}, queue} = PriorityQueue.pop(queue)

    if apply_presses(presses, buttons, combo) == buttons do
      cost
    else
      Enum.reduce(Enum.with_index(combo), queue, fn
        {0, i}, acc ->
          l = List.replace_at(combo, i, 1)
          # cost is number of presses in this sequence
          PriorityQueue.put(acc, cost + 1, l)

        {_, _}, acc ->
          acc
      end)
      |> find_combo({buttons, presses, joltage})
    end
  end

  def apply_presses(presses, buttons, combo) do
    initial_state = Enum.map(buttons, fn _ -> false end)

    Enum.reduce(Enum.with_index(presses), initial_state, fn {press, index}, acc ->
      if Enum.at(combo, index) == 1, do: press_button(acc, press), else: acc
    end)
  end

  def press_button(buttons, button) do
    Enum.reduce(button, buttons, fn i, acc ->
      List.update_at(acc, i, fn b -> not b end)
    end)
  end
end
