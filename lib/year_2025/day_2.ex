defmodule Year2025.Day2 do
  @moduledoc """
  --- Day 2: Gift Shop ---

  Identifies invalid product IDs in the gift shop database.
  Invalid IDs are those where the entire number is a pattern repeated exactly twice
  (e.g., 11, 6464, 123123).
  """

  @data_path "lib/inputs/2025/day_2/input.txt"

  alias Infrastructure.FileIO.InputFileLoader

  @doc """
  Solves Part 1: Sum of all invalid product IDs in the given ranges.
  """
  def part_1, do: solve(@data_path, &solve_part_1/1)

  @doc """
  Solves Part 2.
  """
  def part_2, do: solve(@data_path, &solve_part_2/1)

  defp solve(path, solver) do
    path
    |> load_input()
    |> solver.()
  end

  defp load_input(path) do
    case InputFileLoader.read_input(path) do
      {:ok, content} -> parse_input(content)
      {:error, reason} -> raise "Failed to read input: #{reason}"
    end
  end

  @doc """
  Parses comma-separated ranges like "11-22,95-115" into a list of range maps.

  ## Examples
      iex> Year2025.Day2.parse_input("11-22,95-115")
      [%{start: 11, end: 22}, %{start: 95, end: 115}]
  """
  def parse_input(content) do
    content
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  @doc """
  Solves Part 1: Sum all invalid product IDs across all ranges.
  """
  def solve_part_1(ranges) do
    ranges
    |> Enum.map(&sum_invalid_ids_in_range/1)
    |> Enum.sum()
  end

  @doc """
  Solves Part 2 with the parsed input.
  """
  def solve_part_2(_input) do
    # To come soon
    0
  end

  defp parse_range(range_string) do
    [start_id, end_id] =
      range_string
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    %{start: start_id, end: end_id}
  end

  defp sum_invalid_ids_in_range(%{start: first, end: last}) do
    first..last
    |> Enum.reject(&valid_product_id?/1)
    |> Enum.sum()
  end

  defp valid_product_id?(product_id) do
    digits = Integer.digits(product_id)

    cond do
      odd_length_number?(digits) ->
        true

      distinct_number_half_pattern?(digits) ->
        true

      true ->
        false
    end
  end

  defp odd_length_number?(digits) when rem(length(digits), 2) == 1, do: true
  defp odd_length_number?(_digits), do: false

  defp distinct_number_half_pattern?(digits) do
    len = length(digits)
    {first_half, second_half} = Enum.split(digits, div(len, 2))
    first_half != second_half
  end
end
