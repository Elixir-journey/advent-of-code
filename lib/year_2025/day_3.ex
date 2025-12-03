defmodule Year2025.Day3 do
  @moduledoc """
  --- Day 3: Lobby ---

  ## Part 1
  ### Summarize what you need to achieve.

  ## Part 2
  ### Summarize what you need to achieve.
  """

  @data_path_part_1 "lib/inputs/2025/day_3/part_1.txt"
  @data_path_part_2 "lib/inputs/2025/day_3/part_2.txt"

  alias Infrastructure.FileIO.InputFileLoader

  @doc """
  Solves Part 1.
  """
  def part_1, do: solve(@data_path_part_1, &solve_part_1/1)

  @doc """
  Solves Part 2.
  """
  def part_2, do: solve(@data_path_part_2, &solve_part_2/1)

  defp solve(path, solver) do
    path
    |> load_input()
    |> solver.()
  end

  defp load_input(path) do
    with {:ok, content} <- InputFileLoader.read_input(path) do
      parse_input(content)
    else
      {:error, reason} -> raise "Failed to read input: #{reason}"
    end
  end

  @doc """
  Parses the raw input into a usable data structure.
  """
  def parse_input(content) do
    content
    |> String.trim()
    |> String.split("\n")
    # TODO: Add parsing logic
  end

  @doc """
  Solves Part 1 with the parsed input.
  """
  def solve_part_1(input) do
    # TODO: Implement
    input
    |> length()
  end

  @doc """
  Solves Part 2 with the parsed input.
  """
  def solve_part_2(input) do
    # TODO: Implement
    input
    |> length()
  end
end
