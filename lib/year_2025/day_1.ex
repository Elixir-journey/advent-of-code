defmodule Year2025.Day1 do
  @moduledoc """
  --- Day 1: Secret Entrance ---
  Count the number of times the dial lands on 0 after each rotation.
  """

  alias Infrastructure.FileIO.InputFileLoader

  @input_path "lib/inputs/2025/day_1/input.txt"

  @dial_positions 100
  @starting_position 50
  @target_position 0

  # Public Solution APIs

  @spec part_1() :: non_neg_integer() | {:error, any()}
  def part_1 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> door_lock_combination_code(content)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec part_2() :: non_neg_integer() | {:error, any()}
  def part_2 do
    case InputFileLoader.read_input(@input_path) do
      {:ok, content} -> solve_part_2(content)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Counts how many times the dial lands on #{@target_position}.

  ## Examples

      iex> input = "L68\\nL30\\nR48\\nL5\\nR60\\nL55\\nL1\\nL99\\nR14\\nL82"
      iex> Year2025.Day1.door_lock_combination_code(input)
      3
  """
  @spec door_lock_combination_code(String.t()) :: non_neg_integer()
  def door_lock_combination_code(input) do
    input
    |> parse()
    |> dial_positions()
    |> Enum.count(&(&1 == @target_position))
  end

  @spec solve_part_2(String.t()) :: non_neg_integer()
  def solve_part_2(input) do
    input |> parse() |> length()
  end

  # Domain Logic

  @doc """
  Returns all dial positions after applying each rotation sequentially,
  starting from position #{@starting_position}.

  ## Examples

      iex> Year2025.Day1.dial_positions([-68, -30, 48])
      [82, 52, 0]
  """
  @spec dial_positions([integer()]) :: [non_neg_integer()]
  def dial_positions(rotations) do
    Enum.scan(rotations, @starting_position, &apply_rotation/2)
  end

  defp apply_rotation(rotation, current) do
    Integer.mod(current + rotation, @dial_positions)
  end

  # Parsing

  @doc """
  Parses input into signed rotation values. L (left) becomes negative, R (right) positive.

  ## Examples

      iex> Year2025.Day1.parse("L68\\nR30\\nL5")
      [-68, 30, -5]
  """
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
