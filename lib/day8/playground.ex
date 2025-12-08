defmodule Playground do
  # https://adventofcode.com/2025/day/8
  def part_one(input, iterations \\ 10) do
    AdventOfCode.read_lines(__DIR__, input)
    |> parse_input()
    |> find_edges()
    |> Enum.take(iterations)
    |> find_circuits(MapSet.new(), 100_000)
  end

  def part_two(input) do
    nodes = AdventOfCode.read_lines(__DIR__, input) |> parse_input()

    nodes
    |> find_edges()
    |> find_circuits(MapSet.new(), length(nodes))
  end

  def parse_input(input) do
    Enum.map(input, fn line ->
      String.split(line, ",") |> Enum.map(&String.to_integer/1)
    end)
  end

  def find_edges(nodes) do
    Enum.reduce(nodes, [], fn i, acc ->
      Enum.reduce(nodes, acc, fn j, bcc ->
        case euclidean_distance(i, j) do
          0 -> bcc
          dist -> [{{i, j}, dist} | bcc]
        end
      end)
    end)
    |> Enum.uniq_by(fn {{a, b}, _} -> Enum.sort([a, b]) end)
    |> Enum.sort_by(fn {_, c} -> c end)
  end

  # https://en.wikipedia.org/wiki/Euclidean_distance
  def euclidean_distance([p1, p2, p3], [q1, q2, q3]) do
    :math.sqrt(:math.pow(p1 - q1, 2) + :math.pow(p2 - q2, 2) + :math.pow(p3 - q3, 2)) |> round()
  end

  def find_circuits([], circuits, _target) do
    MapSet.to_list(circuits)
    |> Enum.sort_by(&MapSet.size/1, :desc)
    |> Enum.take(3)
    |> Enum.reduce(1, fn circuit, product -> MapSet.size(circuit) * product end)
  end

  # use MapSets to store each circuit for easy lookup / merging
  def find_circuits([edge | edges], circuits, target) do
    {{a, b}, _cost} = edge
    circuit_a = find_node(circuits, a)
    circuit_b = find_node(circuits, b)

    if MapSet.equal?(circuit_a, circuit_b) do
      find_circuits(edges, circuits, target)
    else
      # merge the circuits
      circuits = merge_circuits(circuits, circuit_a, circuit_b)

      if all_connected?(circuits, target) do
        Enum.at(a, 0) * Enum.at(b, 0)
      else
        find_circuits(edges, circuits, target)
      end
    end
  end

  def find_node(circuits, node) do
    Enum.find(circuits, MapSet.new([node]), fn circuit -> node in circuit end)
  end

  def merge_circuits(circuits, circuit_a, circuit_b) do
    circuits
    |> MapSet.delete(circuit_a)
    |> MapSet.delete(circuit_b)
    |> MapSet.put(MapSet.union(circuit_a, circuit_b))
  end

  def all_connected?(circuits, target) do
    MapSet.size(circuits) == 1 and
      case MapSet.to_list(circuits) do
        [c] -> MapSet.size(c) == target
        _ -> false
      end
  end
end
