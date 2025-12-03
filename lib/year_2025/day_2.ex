defmodule Year2025.Day2 do
  @moduledoc """
  --- Day 2: Gift Shop ---
  Identifies invalid product IDs in the gift shop database.
  ## Part 1
  Invalid IDs are those where the entire number is a pattern repeated exactly twice
  (e.g., 11, 6464, 123123).
  ## Part 2
  Invalid IDs are those where the entire number is a pattern repeated at least twice
  (e.g., 12341234, 123123123, 1212121212, 1111111).
  """

  @data_path "lib/inputs/2025/day_2/input.txt"

  alias Infrastructure.FileIO.InputFileLoader

  @doc """
  Solves Part 1: Sum of all invalid product IDs (pattern repeated exactly twice).
  """
  def part_1, do: solve(@data_path, :part_1)

  @doc """
  Solves Part 2: Sum of all invalid product IDs (pattern repeated at least twice).
  """
  def part_2, do: solve(@data_path, :part_2)

  defp solve(path, part) do
    path
    |> load_input()
    |> solve_for_part(part)
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

      iex> Year2025.Day2.parse_input("998-1012")
      [%{start: 998, end: 1012}]
  """
  def parse_input(content) do
    content
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_range/1)
  end

  @doc """
  Solves Part 1: Sum all invalid product IDs across all ranges.

  Invalid IDs are patterns repeated exactly twice.

  ## Examples
      iex> Year2025.Day2.solve_part_1([%{start: 11, end: 22}])
      33

      iex> Year2025.Day2.solve_part_1([%{start: 95, end: 115}])
      99

      iex> Year2025.Day2.solve_part_1([%{start: 998, end: 1012}])
      1010
  """
  def solve_part_1(ranges) do
    solve_for_part(ranges, :part_1)
  end

  @doc """
  Solves Part 2: Sum all invalid product IDs across all ranges.

  Invalid IDs are patterns repeated at least twice.

  ## Examples
      iex> Year2025.Day2.solve_part_2([%{start: 11, end: 22}])
      33

      iex> Year2025.Day2.solve_part_2([%{start: 111, end: 111}])
      111

      iex> Year2025.Day2.solve_part_2([%{start: 123123123, end: 123123123}])
      123123123
  """
  def solve_part_2(ranges) do
    solve_for_part(ranges, :part_2)
  end

  defp solve_for_part(ranges, part) do
    ranges
    |> Task.async_stream(
      &sum_invalid_ids_in_range(&1, part),
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.reduce(0, fn {:ok, sum}, acc -> acc + sum end)
  end

  defp parse_range(range_string) do
    [start_id, end_id] =
      range_string
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    %{start: start_id, end: end_id}
  end

  defp sum_invalid_ids_in_range(%{start: first, end: last}, part) do
    first..last
    |> Enum.reject(&valid_product_id?(&1, part))
    |> Enum.sum()
  end

  defp valid_product_id?(product_id, part) do
    case part do
      :part_1 -> not repeated_exactly_twice?(product_id)
      :part_2 -> not has_repeating_pattern?(product_id)
    end
  end

  # Part 1: Check if the number is a pattern repeated exactly twice
  defp repeated_exactly_twice?(product_id) do
    digits = Integer.digits(product_id)
    len = length(digits)

    # Must have even length and split into two identical halves
    rem(len, 2) == 0 && duplicated_halves?(digits)
  end

  defp duplicated_halves?(digits) do
    len = length(digits)
    {first_half, second_half} = Enum.split(digits, div(len, 2))
    first_half == second_half
  end

  # Part 2: Check if the number has any repeating pattern (2+ times)
  defp has_repeating_pattern?(product_id) do
    digits = Integer.digits(product_id)
    len = length(digits)
    max_pattern_len = div(len, 2)

    max_pattern_len >= 1 and
      Enum.any?(1..max_pattern_len//1, fn pattern_len ->
        rem(len, pattern_len) == 0 and repeats_digit_pattern?(digits, pattern_len)
      end)
  end

  defp repeats_digit_pattern?(digits, pattern_len) do
    pattern = Enum.take(digits, pattern_len)

    digits
    |> Enum.chunk_every(pattern_len)
    |> Enum.all?(&(&1 == pattern))
  end
end
