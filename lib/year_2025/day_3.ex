defmodule Year2025.Day3 do
  @moduledoc """
  --- Day 3: Lobby ---

  ## Part 1

  Find the maximum joltage for each battery bank by selecting two batteries
  where the first comes before the second, forming a two-digit number.
  Sum all maximum joltages across all battery banks.

  ## Part 2

  TODO
  """

  @data_path "lib/inputs/2025/day_3/input.txt"

  alias Infrastructure.FileIO.InputFileLoader

  # Public Solution APIs

  @spec part_1() :: non_neg_integer()
  def part_1, do: solve(@data_path, &maximum_joltage_for_battery_banks/1)

  @spec part_2() :: non_neg_integer()
  def part_2, do: solve(@data_path, &solve_part_2/1)

  defp solve(path, solver) do
    path
    |> load_input()
    |> solver.()
  end

  defp load_input(path) do
    with {:ok, content} <- InputFileLoader.read_input(path) do
      parse_battery_banks(content)
    else
      {:error, reason} -> raise "Failed to read input: #{reason}"
    end
  end

  @doc """
  Parses the raw input into a list of battery bank integers.

  ## Examples

      iex> Year2025.Day3.parse_battery_banks("12345\\n67890")
      [12345, 67890]
  """
  @spec parse_battery_banks(String.t()) :: [non_neg_integer()]
  def parse_battery_banks(content) do
    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Calculates the sum of maximum joltages across all battery banks.

  For each battery bank, finds the largest two-digit joltage that can be
  produced by selecting two batteries where the first comes before the second.

  ## Examples

      iex> Year2025.Day3.maximum_joltage_for_battery_banks([987654321111111, 811111111111119])
      187

      iex> Year2025.Day3.maximum_joltage_for_battery_banks([234234234234278, 818181911112111])
      170
  """
  @spec maximum_joltage_for_battery_banks([non_neg_integer()]) :: non_neg_integer()
  def maximum_joltage_for_battery_banks(battery_banks) do
    battery_banks
    |> Task.async_stream(
      &find_largest_battery_joltage(&1),
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.reduce(0, fn {:ok, sum}, acc -> acc + sum end)
  end

  @doc """
  Finds the largest two-digit joltage from a single battery bank.

  Selects two batteries (digits) where the first position comes before the second,
  forming the tens and ones digit respectively. Uses a right-to-left scan tracking
  the maximum ones digit seen so far.

  ## Examples

      iex> Year2025.Day3.find_largest_battery_joltage(987654321111111)
      98

      iex> Year2025.Day3.find_largest_battery_joltage(811111111111119)
      89

      iex> Year2025.Day3.find_largest_battery_joltage(234234234234278)
      78

      iex> Year2025.Day3.find_largest_battery_joltage(818181911112111)
      92
  """
  @spec find_largest_battery_joltage(non_neg_integer()) :: non_neg_integer()
  def find_largest_battery_joltage(battery_bank) do
    [last_digit | rest] =
      battery_bank
      |> Integer.digits()
      |> Enum.reverse()

    rest
    |> Enum.reduce({last_digit, 0}, fn digit, {max_ones, best} ->
      joltage = digit * 10 + max_ones
      {max(digit, max_ones), max(joltage, best)}
    end)
    |> elem(1)
  end

  @doc """
  Solves Part 2 with the parsed input.
  """
  @spec solve_part_2([non_neg_integer()]) :: non_neg_integer()
  def solve_part_2(input) do
    # TODO: Implement
    input
    |> length()
  end
end
