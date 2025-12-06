defmodule Mix.Tasks.Day.Input do
  @moduledoc """
  Usage: mix day.input <number>
  """
  @shortdoc "Downloads the puzzle input for a given day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:hackney)

    case OptionParser.parse!(args, strict: []) do
      {_opts, [day]} ->
        if not File.exists?("lib/day#{day}/input.txt") or
             Mix.shell().yes?("Input file already exists. Overwrite? (y/n)") do
          case AdventOfCode.download_input(day) do
            {:ok, input} ->
              Mix.Generator.create_file("lib/day#{day}/input.txt", input)
              Mix.shell().info("Input downloaded and saved to lib/day#{day}/input.txt")

            {:error, reason} ->
              Mix.shell().error("Error downloading puzzle: #{reason}")
          end
        else
          Mix.shell().info("Skipping download.")
        end
    end
  end
end
