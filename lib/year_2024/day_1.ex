defmodule Year2024.Day1 do
  @moduledoc """
  --- Day 1: Historian Hysteria ---

  The Chief Historian has gone missing, and it's up to you to help a group of Senior Historians reconcile their conflicting lists of location IDs.

  ## Part 1: Total Distance
  Pair up the smallest number in the left list with the smallest number in the right list,
  then the second-smallest left number with the second-smallest right number, and so on.
  Within each pair, figure out how far apart the two numbers are; you'll need to add up all of those distances.

  ## Part 2: Similarity Score
  Calculate a total similarity score by adding up each number in the left list after multiplying it by
  the number of times that number appears in the right list.
  """
  @data_path_part_1 "lib/inputs/2024/day_1/part_1.txt"
  @data_path_part_2 "lib/inputs/2024/day_1/part_2.txt"

  import Infrastructure.Enum.CommonHelpers, only: [build_frequency_map: 1]
  alias Infrastructure.InputFileLoader

  @doc """
  Calculates the sum of absolute differences between sorted columns from `part_1` data.
  """
  def part_1 do
    {fst_col_location_ids, snd_col_location_ids} =
      load_and_extract_columns(@data_path_part_1)

    fst_col_location_ids
    |> Enum.sort()
    |> Enum.zip(Enum.sort(snd_col_location_ids))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  @doc """
  Calculates the similarity score based on the frequency of location IDs in `part_2` data.
  """
  def part_2 do
    {fst_col_location_ids, snd_col_location_ids} =
      load_and_extract_columns(@data_path_part_2)

    frequency_map = build_frequency_map(snd_col_location_ids)

    Enum.reduce(fst_col_location_ids, 0, fn location_id, acc ->
      acc + location_id * Map.get(frequency_map, location_id, 0)
    end)
  end

  defp load_and_extract_columns(file_path) do
    with {:ok, content} <- InputFileLoader.read_input(file_path),
         {:ok, parsed_lines} <- InputFileLoader.extract_lines_from_text(content) do
      parsed_lines
      |> Enum.map(fn [column_1, column_2] ->
        {String.to_integer(column_1), String.to_integer(column_2)}
      end)
      |> Enum.unzip()
    else
      {:error, reason} ->
        raise "Failed to process file at #{file_path}: #{reason}"
    end
  end
end
