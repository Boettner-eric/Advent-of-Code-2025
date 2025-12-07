defmodule AdventOfCode do
  @moduledoc """
  This module contains functions to help with the Advent of Code challenge.
  """
  @year 2025

  @type filename :: :sample | :input | String.t()

  @spec resolve_path(String.t(), filename()) :: String.t()
  def resolve_path(directory, :sample), do: Path.join([directory, "sample.txt"])
  def resolve_path(directory, :input), do: Path.join([directory, "input.txt"])
  def resolve_path(_, "lib/" <> filename), do: "lib/" <> filename
  def resolve_path(directory, filename), do: Path.join([directory, filename])

  @doc """
  Reads a file and returns a list of lines.
  If the filename is :sample or :input, it will read the sample or input file for the current day.
  If a given day has a unique input file, you can pass the relative filename as a string or pass
  an absolute path to the file.

  ## Examples

      iex> AdventOfCode.read_lines("example.txt")
      ["this is the first list", "it continues on the next line", "and this is the third line"]

      iex> AdventOfCode.read_lines(:sample)
      ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]


      iex> AdventOfCode.read_lines("lib/other_dir/example.txt")
      ["data", "more data]

  """
  @spec read_lines(String.t(), filename()) :: list(String.t())
  def read_lines(directory, filename) do
    case File.read(resolve_path(directory, filename)) do
      {:ok, input} -> String.split(input, "\n", trim: true)
      {:error, reason} -> raise "Error reading file: #{reason}"
    end
  end

  @doc """
  Reads a file and returns its whole contents as a string.
  This is useful for reading odd inputs that need to be parsed differently than just lines.

  ## Examples

      iex> AdventOfCode.read_blob("example.txt")
      "this is the first list\nit continues on the next line\nand this is the third line"

  """
  @spec read_blob(String.t(), filename()) :: String.t()
  def read_blob(directory, filename) do
    case File.read(resolve_path(directory, filename)) do
      {:ok, input} -> input
      {:error, reason} -> raise "Error reading file: #{reason}"
    end
  end

  @doc """
  Downloads the puzzle input for a given day.
  """
  @spec download_input(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def download_input(day) do
    HTTPoison.get("https://adventofcode.com/#{@year}/day/#{day}/input", [],
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
end
