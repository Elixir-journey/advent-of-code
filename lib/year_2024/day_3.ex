defmodule Year2024.Day3 do
  @moduledoc """
  --- Day 3: Mull It Over ---
  """

  @data_path_part_1 "lib/inputs/2024/day_3/part_1.txt"
  @mul_instructions_regex ~r/mul\((\d{1,3}),(\d{1,3})\)/

  @doc """
  Sum the results of all uncorrupted multiplication instructions from the rental shop computer memory logs.
  """
  def part_1,
    do: solve(@data_path_part_1, @mul_instructions_regex, process_valid_mul_instructions())

  def solve(path, regex, transform) do
    path
    |> File.stream!()
    |> Stream.flat_map(&Regex.scan(regex, &1))
    |> Stream.transform(nil, transform)
    |> Enum.sum()
  end

  defp process_valid_mul_instructions do
    fn
      # The regex should already check that we get a valid mul instructions.
      ["mul(" <> _, x, y], nil ->
        {[String.to_integer(x) * String.to_integer(y)], nil}

      # ignore unrecognized input
      _other, state ->
        {[], state}
    end
  end
end
