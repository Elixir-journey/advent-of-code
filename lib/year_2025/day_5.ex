defmodule Year2025.Day5 do
  @moduledoc """
  --- Day 5: Cafeteria ---

  ## Part 1
  ### Summarize what you need to achieve.

  ## Part 2
  ### Summarize what you need to achieve.
  """

  @data_path "lib/inputs/2025/day_5/input.txt"

  alias Infrastructure.FileIO.InputFileLoader

  @doc """
  Solves Part 1.
  """
  def part_1, do: solve(@data_path, &count_all_fresh_ingredients_left/1)

  @doc """
  Solves Part 2.
  """
  def part_2, do: solve(@data_path, &solve_part_2/1)

  defp solve(path, solver) do
    path
    |> load_input()
    |> solver.()
  end

  defp load_input(path) do
    with {:ok, content} <- InputFileLoader.read_input(path) do
      parse_ingredient_id_from_text(content)
    else
      {:error, reason} -> raise "Failed to read input: #{reason}"
    end
  end

  @doc """
  Parses the raw input into a usable data structure.
  """
  def parse_ingredient_id_from_text(content) do
    content
    |> String.trim()
    |> String.split("\n\n")
  end

  @doc """
  Solves Part 1 with the parsed input.
  """
  def count_all_fresh_ingredients_left(ingredients_database) do
    [ingredient_id_ranges, ingredient_ids] = ingredients_database

    fresh_ingredients_db = condense_fresh_ingredient_db(ingredient_id_ranges)

    ingredient_ids
    |> Task.async_stream(
      &ingredient_exists_in_fresh_db?(&1, fresh_ingredients_db),
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.reject(fn {:error, _} -> true end)
    |> Enum.map(fn _ -> 1 end)
    |> Enum.sum()
  end

  # We have to ensure the data is ordered (Ranges are monotonically increasing  1 -> 2, 1->3 2->4 2->5 boils down to 1 -> 5)
  def condense_fresh_ingredient_db(raw_ingredient_ranges) do
    ranges = build_fresh_ranges_from_raw_input(raw_ingredient_ranges)
  end

  defp build_fresh_ranges_from_raw_input(raw_ingredient_ranges) do
    raw_ingredient_ranges
    |> String.split("\n")
    |> Enum.flat_map(fn range -> String.split(range, "-") end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [min, max] -> Range.new(min, max) end)
  end

  # TODO: Binary search on the edges of a range
  # TODO: We'll start at (length(fresh_db) / 2 + 1)
  defp ingredient_exists_in_fresh_db?(ingredient_id, fresh_ingredient_db) do
  end

  @doc """
  Solves Part 2 with the parsed input.
  """
  def solve_part_2(input) do
    # TODO: Implement
    input
    |> length()
  end
end
