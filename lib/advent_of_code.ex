defmodule AdventOfCode do
  @moduledoc """
  This module contains functions to help with the Advent of Code challenge.
  """

  @doc """
  Reads a file and returns a list of lines.

  ## Examples

      iex> AdventOfCode.read_lines("example.txt")
      ["this is the first list", "it continues on the next line", "and this is the third line"]

  """
  def read_lines(filename) do
    {:ok, input} = File.read(filename)

    String.split(input, "\n", trim: true)
  end

  @doc """
  Reads a file and returns its whole contents as a string.
  This is useful for reading odd inputs that need to be parsed differently than just lines.

  ## Examples

      iex> AdventOfCode.read_blob("example.txt")
      "this is the first list\nit continues on the next line\nand this is the third line"

  """
  def read_blob(filename) do
    {:ok, input} = File.read(filename)

    input
  end
end
