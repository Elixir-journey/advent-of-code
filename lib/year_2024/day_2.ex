defmodule Year2024.Day2 do
  @moduledoc """
  --- Day 2: Historian Hysteria ---

  The Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian.
  In the plant, historians are divided in groups inspecting data.

  ## Part 1: How many safe reports?

  The data seems to consist of many reports. Each report is a list of numbers called levels that are separated by spaces.
  The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing.
  7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
  1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
  Any two adjacent levels differ by at least one and at most three.
  The goal of part 1 is to count of many reports are safe from the input.
  """

  @data_path_part_1 "lib/inputs/2024/day_2/part_1.txt"
  @min_diff 1
  @max_diff 3

  alias Infrastructure.InputFileLoader
  import Infrastructure.Enum.CommonHelpers

  @doc """
  Counts of many safe reports can be observed from the input data in part_1.txt
  """
  def part_1 do
    with {:ok, reports} <- InputFileLoader.get_parsed_lines(@data_path_part_1) do
      reports
      |> Enum.map(&convert_strings_to_integers/1)
      |> Enum.filter(fn report -> safe_report?(report, @min_diff, @max_diff) end)
      |> Enum.count()
    end
  end

  defp safe_report?(levels, min_diff, max_diff) do
    case levels do
      [_] ->
        # Single-element lists are considered safe
        true

      [] ->
        # Empty lists are not safe
        false

      _ ->
        (strictly_increasing?(levels) or strictly_decreasing?(levels)) and
          adjacent_values_in_range?(levels, min_diff, max_diff)
    end
  end
end
