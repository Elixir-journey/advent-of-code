defmodule Year2024.Day1 do
  @data_path_part_1 "lib/inputs/2024/day_1/input.txt"
  @space_between_column_regex ~r/\s+/

  def part_1() do
    @data_path_part_1
    |> Infrastructure.InputFileLoader.read_input()
    |> Enum.map(fn row ->
      String.split(row, @space_between_column_regex, trim: true)
    end)
    |> Enum.map(fn [column_1, column_2] ->
      {String.to_integer(column_1), String.to_integer(column_2)}
    end)
    |> Enum.unzip()
    |> then(fn {column_1, column_2} ->
      {Enum.sort(column_1), Enum.sort(column_2)}
    end)
    |> then(fn {sorted_column_1, sorted_column_2} ->
      Enum.zip(sorted_column_1, sorted_column_2)
      |> Enum.map(fn {a, b} -> abs(b - a) end)
    end)
    |> Enum.sum()
  end
end
