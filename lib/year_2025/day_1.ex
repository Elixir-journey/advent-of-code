defmodule Year2025.Day1 do
  @moduledoc """
  --- Day 1: Secret Entrance ---

  Count the number of times the dial lands on 0 after each rotation.
  """

  @input_path "lib/inputs/2025/day_1/part_1.txt"
  @dial_size 100
  @init_dial 50

  # Public Solution APIs

  def part_1, do: @input_path |> File.read!() |> solve_part_1()
  def part_2, do: @input_path |> File.read!() |> solve_part_2()

  @doc """
  Counts how many times the dial lands on 0.

  ## Examples

      iex> input = "L68\\nL30\\nR48\\nL5\\nR60\\nL55\\nL1\\nL99\\nR14\\nL82"
      iex> Year2025.Day1.solve_part_1(input)
      3

  """
  def solve_part_1(input) do
    input
    |> parse()
    |> Enum.reduce(%{dial: @init_dial, count: 0}, fn rotation, %{dial: dial, count: count} ->
      new_dial = rotate_dial(dial, rotation)
      %{dial: new_dial, count: if(new_dial == 0, do: count + 1, else: count)}
    end)
    |> Map.get(:count)
  end

  def solve_part_2(input) do
    # TODO: Implement
    input |> parse() |> length()
  end

  # Parsing

  @doc """
  Parses input into list of signed rotation values.

  ## Examples

      iex> Year2025.Day1.parse("L10\\nR5\\nL100")
      [-10, 5, -100]

  """
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_rotation/1)
  end

  # Helpers

  defp rotate_dial(current, rotation) do
    Integer.mod(current + rotation, @dial_size)
  end

  defp parse_rotation("L" <> distance), do: -String.to_integer(distance)
  defp parse_rotation("R" <> distance), do: String.to_integer(distance)
end
