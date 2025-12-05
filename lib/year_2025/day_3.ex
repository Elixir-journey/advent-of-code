defmodule Year2025.Day3 do
  @moduledoc """
  --- Day 3: Lobby ---

  ## Part 1

  Find the maximum joltage for each battery bank by selecting 2 batteries
  (maintaining order) to form a two-digit number. Sum all maximum joltages.

  ## Part 2

  Same as Part 1, but select 12 batteries to form a twelve-digit number.
  """

  alias Infrastructure.FileIO.InputFileLoader

  @input_path "lib/inputs/2025/day_3/input.txt"
  @part_1_digits 2
  @part_2_digits 12

  # Public Solution APIs

  @spec part_1() :: non_neg_integer() | {:error, any()}
  def part_1 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> maximum_joltage_for_battery_banks(content)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec part_2() :: non_neg_integer() | {:error, any()}
  def part_2 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> maximum_joltage_for_battery_banks(content, @part_2_digits)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Calculates the sum of maximum joltages across all battery banks.

  ## Examples

      iex> input = "987654321111111\\n811111111111119\\n234234234234278\\n818181911112111"
      iex> Year2025.Day3.maximum_joltage_for_battery_banks(input)
      357

      iex> input = "987654321111111\\n811111111111119\\n234234234234278\\n818181911112111"
      iex> Year2025.Day3.maximum_joltage_for_battery_banks(input, 12)
      3121910778619
  """
  @spec maximum_joltage_for_battery_banks(String.t(), pos_integer()) :: non_neg_integer()
  def maximum_joltage_for_battery_banks(input, digit_count \\ @part_1_digits) do
    input
    |> parse_battery_bank_voltage()
    |> sum_joltages(digit_count)
  end

  # Domain Logic

  @spec sum_joltages([non_neg_integer()], pos_integer()) :: non_neg_integer()
  defp sum_joltages(battery_banks, digit_count) do
    battery_banks
    |> Task.async_stream(
      &find_largest_joltage(&1, digit_count),
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.map(fn {:ok, joltage} -> joltage end)
    |> Enum.sum()
  end

  @doc """
  Finds the largest joltage by selecting `count` digits from a battery bank.

  Uses a greedy algorithm: for each position, pick the largest digit
  that still leaves enough remaining digits to fill the rest.

  ## Examples

      iex> Year2025.Day3.find_largest_joltage(987654321111111, 2)
      98

      iex> Year2025.Day3.find_largest_joltage(818181911112111, 2)
      92

      iex> Year2025.Day3.find_largest_joltage(987654321111111, 12)
      987654321111

      iex> Year2025.Day3.find_largest_joltage(811111111111119, 12)
      811111111119
  """
  @spec find_largest_joltage(non_neg_integer(), pos_integer()) :: non_neg_integer()
  def find_largest_joltage(battery_bank, batteries_to_turn_on) do
    voltages = Integer.digits(battery_bank)
    bank_size = length(voltages)

    voltages
    |> List.to_tuple()
    |> select_digits(bank_size, _start = 0, batteries_to_turn_on, [])
    |> Enum.reverse()
    |> Integer.undigits()
  end

  @spec select_digits(tuple(), non_neg_integer(), non_neg_integer(), non_neg_integer(), [0..9]) ::
          [0..9]
  defp select_digits(_voltages, _bank_size, _start, _remaining = 0, acc), do: acc

  defp select_digits(voltages, bank_size, start, remaining, acc) do
    end_idx = bank_size - remaining
    {max_digit, max_idx} = max_digit_in_range(voltages, start, end_idx)

    select_digits(voltages, bank_size, max_idx + 1, remaining - 1, [max_digit | acc])
  end

  @spec max_digit_in_range(tuple(), non_neg_integer(), non_neg_integer()) ::
          {0..9, non_neg_integer()}
  defp max_digit_in_range(voltages, start, end_idx) do
    initial = {elem(voltages, start), start}

    Enum.reduce((start + 1)..end_idx//1, initial, fn i, {max_digit, max_idx} ->
      digit = elem(voltages, i)
      if digit > max_digit, do: {digit, i}, else: {max_digit, max_idx}
    end)
  end

  # Parsing

  @doc """
  Parses the raw input into a list of battery bank integers.

  ## Examples

      iex> Year2025.Day3.parse_battery_bank_voltage("12345\\n67890")
      [12345, 67890]
  """
  @spec parse_battery_bank_voltage(String.t()) :: [non_neg_integer()]
  def parse_battery_bank_voltage(content) do
    content
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
