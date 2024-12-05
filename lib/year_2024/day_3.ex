defmodule Year2024.Day3 do
  @moduledoc """
  --- Day 3: Mull It Over ---
  """

  @data_path_part_1 "lib/inputs/2024/day_3/part_1.txt"
  @mul_instructions_regex ~r/mul\((\d{1,3}),(\d{1,3})\)/

  @doc """
  Sum the results of all uncorrupted multiplication instructions from the rental shop computer memory logs.
  """
  def part_1, do: solve(@data_path_part_1, @mul_instructions_regex)

  defp solve(path, regex) do
  end
end
