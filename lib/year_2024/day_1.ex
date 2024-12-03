defmodule Year2024.Day1 do
  @moduledoc """
  --- Day 1: Historian Hysteria ---

  ## Part 1: Total Distance
  Calculate the sum of absolute differences between sorted columns.

  ## Part 2: Similarity Score
  Compute the similarity score by multiplying each left column ID by its frequency in the right column.
  """

  @data_path_part_1 "lib/inputs/2024/day_1/part_1.txt"
  @data_path_part_2 "lib/inputs/2024/day_1/part_2.txt"

  import Infrastructure.Enum.CommonHelpers, only: [build_frequency_map: 1]
  alias Infrastructure.InputFileLoader

  @doc """
  Calculates the sum of absolute differences for Part 1.
  """
  def part_1, do: solve(@data_path_part_1, &total_distance/1)

  @doc """
  Calculates the similarity score for Part 2.
  """
  def part_2, do: solve(@data_path_part_2, &similarity_score/1)

  defp solve(path, operation) do
    path
    |> load_columns()
    |> operation.()
  end

  defp load_columns(path) do
    with {:ok, content} <- InputFileLoader.read_input(path),
         {:ok, parsed_lines} <- InputFileLoader.extract_lines_from_text(content) do
      parsed_lines
      |> Enum.map(&parse_row/1)
      |> Enum.unzip()
    else
      {:error, reason} -> raise "Failed to process file at #{path}: #{reason}"
    end
  end

  defp parse_row([col1, col2]), do: {String.to_integer(col1), String.to_integer(col2)}

  defp total_distance({col1, col2}) do
    Enum.sort(col1)
    |> Enum.zip(Enum.sort(col2))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  defp similarity_score({col1, col2}) do
    frequency_map = build_frequency_map(col2)

    Enum.reduce(col1, 0, fn id, acc ->
      acc + id * Map.get(frequency_map, id, 0)
    end)
  end
end
