defmodule Year2024.Day2 do
  @moduledoc """
  --- Day 2: The Red-Nosed Reindeer ---
  """

  @data_path_part_1 "lib/inputs/2024/day_2/part_1.txt"
  @data_path_part_2 "lib/inputs/2024/day_2/part_2.txt"
  @min_diff 1
  @max_diff 3

  alias Infrastructure.InputFileLoader
  import Infrastructure.Enum.CommonHelpers, only: [convert_strings_to_integers: 1, pairwise: 1]

  @doc """
  Count the number of safe reports for Part 1.
  """
  def part_1, do: solve(@data_path_part_1, &is_safe_report/1)

  @doc """
  Count the number of safe reports for Part 2.
  """
  def part_2, do: solve(@data_path_part_2, &is_safe_with_tolerance/1)

  defp solve(path, filter) do
    path
    |> load_reports()
    |> Enum.filter(filter)
    |> length()
  end

  defp load_reports(path) do
    InputFileLoader.get_parsed_lines(path)
    |> case do
      {:ok, reports} -> Enum.map(reports, &convert_strings_to_integers/1)
      {:error, _reason} -> []
    end
  end

  defp is_safe_report(levels) do
    is_monotonic?(levels) and adjacent_differences_in_range?(levels)
  end

  defp is_safe_with_tolerance(levels) do
    Enum.any?(0..(length(levels) - 1), fn index ->
      levels
      |> List.delete_at(index)
      |> is_safe_report()
    end)
  end

  defp is_monotonic?(levels) do
    pairs = pairwise(levels)

    Enum.all?(pairs, fn {a, b} -> a <= b end) or
      Enum.all?(pairs, fn {a, b} -> a >= b end)
  end

  defp adjacent_differences_in_range?(levels) do
    pairwise(levels)
    |> Enum.all?(fn {a, b} ->
      diff = abs(a - b)
      diff >= @min_diff and diff <= @max_diff
    end)
  end
end
