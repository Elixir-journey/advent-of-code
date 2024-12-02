defmodule Year2024.Day1 do
  @data_path_part_1 "lib/inputs/2024/day_1/part_1.txt"
  @data_path_part_2 "lib/inputs/2024/day_1/part_2.txt"
  @space_between_column_regex ~r/\s+/

  import Infrastructure.Enum.CommonHelpers, only: [build_frequency_map: 1]

  def part_1() do
    {fst_col_location_ids, snd_col_location_ids} =
      extract_location_id_rows_from_input(@data_path_part_1)

    fst_col_location_ids = Enum.sort(fst_col_location_ids)
    snd_col_location_ids = Enum.sort(snd_col_location_ids)

    fst_col_location_ids
    |> Enum.zip(snd_col_location_ids)
    |> Enum.map(fn {a, b} -> abs(b - a) end)
    |> Enum.sum()
  end

  def part_2() do
    {fst_col_location_ids, snd_col_location_ids} =
      extract_location_id_rows_from_input(@data_path_part_2)

    frequency_map = build_frequency_map(snd_col_location_ids)

    Enum.reduce(fst_col_location_ids, 0, fn location_id, acc ->
      acc + location_id * Map.get(frequency_map, location_id, 0)
    end)
  end

  defp extract_location_id_rows_from_input(file_path) do
    file_path
    |> Infrastructure.InputFileLoader.read_input()
    |> Enum.map(fn row ->
      String.split(row, @space_between_column_regex, trim: true)
    end)
    |> Enum.map(fn [column_1, column_2] ->
      {String.to_integer(column_1), String.to_integer(column_2)}
    end)
    |> Enum.unzip()
  end
end
