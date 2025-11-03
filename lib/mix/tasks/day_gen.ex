defmodule Mix.Tasks.Day.Gen do
  @moduledoc """
  Usage: mix day.gen <number> <problem name>
  """
  @shortdoc "Generates all the files needed for an aoc day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:hackney)

    case OptionParser.parse!(args, strict: []) do
      {_opts, [day, name]} ->
        file_name =
          "lib/day#{day}/#{String.split(name, ~r/(?=[A-Z])/, trim: true) |> Enum.join("_") |> String.downcase()}.ex"

        module_name =
          String.split(name, ~r/(?=[A-Z])/, trim: true)
          |> Enum.map(&String.capitalize(&1))
          |> Enum.join("")

        day_name = num_to_name(day)
        test_file_name = "test/days/day_#{String.replace(day_name, " ", "_")}_test.exs"

        case download_input(day) do
          {:ok, input} ->
            Mix.Generator.create_directory("lib/day#{day}")
            Mix.Generator.create_file("lib/day#{day}/input.txt", input)
            Mix.Generator.create_file("lib/day#{day}/sample.txt", "")
            Mix.Generator.create_file(file_name, template_day(module_name, day))
            Mix.Generator.create_file(test_file_name, template_test(module_name, day_name, day))

          {:error, reason} ->
            Mix.shell().error("Error downloading puzzle: #{reason}")
        end

      _ ->
        Mix.shell().error("Invalid arguments. Usage: mix day.gen <number> <name>")
    end
  end

  @doc """
  Downloads the puzzle input for a given day.
  """
  def download_input(day) do
    HTTPoison.get("https://adventofcode.com/2024/day/#{day}/input", [],
      hackney: [cookie: ["session=#{System.get_env("AOC_SESSION_COOKIE")}"]],
      headers: [{"User-Agent", "github.com/Boettner-eric/Advent-of-Code-2025"}]
    )
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Puzzle Not found"}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp template_day(name, day) do
    """
    defmodule #{name} do
      def problem_one(filename \\\\ "lib/day#{day}/input.txt") do
        AdventOfCode.read_lines(filename)
        |> IO.inspect()


      end

      def problem_two(filename \\\\ "lib/day#{day}/input.txt") do
        AdventOfCode.read_lines(filename)
        |> IO.inspect()


      end
    end
    """
  end

  defp template_test(module_name, day_name, day) do
    """
    defmodule #{module_name}Test do
      use ExUnit.Case

      test "day #{day_name}, gets correct answer for sample one" do
        assert #{module_name}.problem_one("lib/day#{day}/sample.txt") == nil
      end

      test "day #{day_name}, gets correct answer for problem one" do
        assert #{module_name}.problem_one() == nil
      end

      test "day #{day_name}, gets correct answer for sample two" do
        assert #{module_name}.problem_two("lib/day#{day}/sample.txt") == nil
      end

      test "day #{day_name}, gets correct answer for problem two" do
        assert #{module_name}.problem_two() == nil
      end
    end
    """
  end

  def num_to_name(s) when is_binary(s), do: num_to_name(String.to_integer(s))
  def num_to_name(0), do: "zero"
  def num_to_name(1), do: "one"
  def num_to_name(2), do: "two"
  def num_to_name(3), do: "three"
  def num_to_name(4), do: "four"
  def num_to_name(5), do: "five"
  def num_to_name(6), do: "six"
  def num_to_name(7), do: "seven"
  def num_to_name(8), do: "eight"
  def num_to_name(9), do: "nine"
  def num_to_name(10), do: "ten"
  def num_to_name(11), do: "eleven"
  def num_to_name(12), do: "twelve"
  def num_to_name(13), do: "thirteen"
  def num_to_name(14), do: "fourteen"
  def num_to_name(15), do: "fifteen"
  def num_to_name(16), do: "sixteen"
  def num_to_name(17), do: "seventeen"
  def num_to_name(18), do: "eighteen"
  def num_to_name(19), do: "nineteen"
  def num_to_name(20), do: "twenty"
  def num_to_name(x) when x > 20 and x < 30, do: "twenty #{num_to_name(x - 20)}"
  def num_to_name(30), do: "thirty"
  def num_to_name(x) when x > 30 and x < 40, do: "thirty #{num_to_name(x - 30)}"
end
