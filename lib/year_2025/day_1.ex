defmodule Year2025.Day1 do
  @moduledoc """
  --- Day 1: Secret Entrance ---
  Count the number of times the dial points at 0.
  """

  alias Infrastructure.FileIO.InputFileLoader

  @input_path "lib/inputs/2025/day_1/input.txt"

  @dial_positions 100
  @starting_position 50

  # Public Solution APIs

  @spec part_1() :: non_neg_integer() | {:error, any()}
  def part_1 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> count_landings_at_zero(content)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec part_2() :: non_neg_integer() | {:error, any()}
  def part_2 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> count_all_times_at_zero(content)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Part 1: Counts how many times the dial lands on 0 after a rotation.

  ## Examples

      iex> input = "L68\\nL30\\nR48\\nL5\\nR60\\nL55\\nL1\\nL99\\nR14\\nL82"
      iex> Year2025.Day1.count_landings_at_zero(input)
      3
  """
  @spec count_landings_at_zero(String.t()) :: non_neg_integer()
  def count_landings_at_zero(input) do
    input
    |> parse()
    |> dial_positions()
    |> Enum.count(&(&1 == 0))
  end

  @doc """
  Part 2: Counts all times the dial points at 0 (landing + passing through).

  ## Examples

      iex> input = "L68\\nL30\\nR48\\nL5\\nR60\\nL55\\nL1\\nL99\\nR14\\nL82"
      iex> Year2025.Day1.count_all_times_at_zero(input)
      6
  """
  @spec count_all_times_at_zero(String.t()) :: non_neg_integer()
  def count_all_times_at_zero(input) do
    input
    |> parse()
    |> count_zeros()
  end

  # Domain Logic

  @spec dial_positions([integer()]) :: [non_neg_integer()]
  def dial_positions(rotations) do
    Enum.scan(rotations, @starting_position, fn rotation, current ->
      Integer.mod(current + rotation, @dial_positions)
    end)
  end

  @spec count_zeros([integer()]) :: non_neg_integer()
  defp count_zeros(rotations) do
    {_final_pos, total} =
      Enum.reduce(rotations, {@starting_position, 0}, fn rotation, {pos, count} ->
        new_pos = Integer.mod(pos + rotation, @dial_positions)
        zeros = count_zeros_in_rotation(pos, rotation)
        {new_pos, count + zeros}
      end)

    total
  end

  @doc """
  Counts how many times we point at 0 during a single rotation.
  Includes landing on 0, but not starting on 0.

  ## Examples
      iex> Year2025.Day1.count_zeros_in_rotation(0, -5)    # L5: starts at 0, doesn't count
      0

      iex> Year2025.Day1.count_zeros_in_rotation(50, -68)  # L68: passes through 0
      1

      iex> Year2025.Day1.count_zeros_in_rotation(82, -30)  # L30: 82 → 52, no zero
      0

      iex> Year2025.Day1.count_zeros_in_rotation(52, 48)   # R48: lands on 0
      1

      iex> Year2025.Day1.count_zeros_in_rotation(95, 60)   # R60: passes through 0
      1

      iex> Year2025.Day1.count_zeros_in_rotation(95, 205)  # R205: passes through 0 three times
      3
  """
  @spec count_zeros_in_rotation(non_neg_integer(), integer()) :: non_neg_integer()
  def count_zeros_in_rotation(start, rotation) when rotation > 0 do
    distance_to_zero = @dial_positions - start

    if rotation >= distance_to_zero do
      1 + div(rotation - distance_to_zero, @dial_positions)
    else
      0
    end
  end

  def count_zeros_in_rotation(start, rotation) when rotation < 0 do
    distance_to_zero = if start == 0, do: @dial_positions, else: start
    abs_rotation = abs(rotation)

    if abs_rotation >= distance_to_zero do
      1 + div(abs_rotation - distance_to_zero, @dial_positions)
    else
      0
    end
  end

  def count_zeros_in_rotation(_start, 0), do: 0

  # Parsing

  @spec parse(String.t()) :: [integer()]
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_rotation/1)
  end

  @spec parse_rotation(String.t()) :: integer()
  defp parse_rotation("L" <> distance), do: -String.to_integer(distance)
  defp parse_rotation("R" <> distance), do: String.to_integer(distance)
end
