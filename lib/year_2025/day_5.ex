defmodule Year2025.Day5 do
  @moduledoc """
  Advent of Code 2025 - Day 5: Cafeteria

  Given a database of fresh ingredient ID ranges and a list of ingredient IDs:
  - Part 1: Count how many ingredient IDs fall within any fresh range
  - Part 2: Count total unique IDs covered by all fresh ranges (after merging overlaps)
  """

  @data_path "lib/inputs/2025/day_5/input.txt"

  alias Infrastructure.FileIO.InputFileLoader

  @type raw_input :: {raw_ranges :: [String.t()], ingredient_ids :: [non_neg_integer()]}

  @doc """
  Solves Part 1: Count ingredient IDs that exist in any fresh range.
  """
  @spec part_1() :: non_neg_integer()
  def part_1, do: solve(@data_path, &count_all_fresh_ingredients_left/1)

  @doc """
  Solves Part 2: Count all unique IDs covered by fresh ranges.
  """
  @spec part_2() :: non_neg_integer()
  def part_2, do: solve(@data_path, &count_total_fresh_ids/1)

  defp solve(path, solver) do
    path
    |> load_input()
    |> solver.()
  end

  defp load_input(path) do
    case InputFileLoader.read_input(path) do
      {:ok, content} ->
        parse_ingredient_id_from_text(content)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Parses raw input text into ranges and ingredient IDs.

  ## Examples

      iex> Year2025.Day5.parse_ingredient_id_from_text("1-3\\n7-10\\n\\n5 8 12")
      {["1-3", "7-10"], [5, 8, 12]}

      iex> Year2025.Day5.parse_ingredient_id_from_text("1-5\\n\\n1,2,3")
      {["1-5"], [1, 2, 3]}
  """
  @spec parse_ingredient_id_from_text(String.t()) :: raw_input()
  def parse_ingredient_id_from_text(content) do
    [range_block, id_block] = content |> String.trim() |> String.split("\n\n")

    {
      String.split(range_block, "\n"),
      id_block
      |> String.split(~r/[\s,]+/)
      |> Enum.map(&String.to_integer/1)
    }
  end

  @doc """
  Counts ingredient IDs that fall within any condensed range.

  ## Examples

      iex> Year2025.Day5.count_all_fresh_ingredients_left({["1-5", "10-15"], [3, 7, 12, 20]})
      2

      iex> Year2025.Day5.count_all_fresh_ingredients_left({["1-3", "2-5"], [1, 3, 5, 6]})
      3
  """
  @spec count_all_fresh_ingredients_left(raw_input()) :: non_neg_integer()
  def count_all_fresh_ingredients_left({raw_ranges, ingredient_ids}) do
    fresh_ranges =
      raw_ranges
      |> build_and_condense_ranges()
      |> List.to_tuple()

    Enum.count(ingredient_ids, &in_ranges?(&1, fresh_ranges))
  end

  @doc """
  Counts total unique IDs covered by all fresh ranges after merging overlaps.

  ## Examples

      iex> Year2025.Day5.count_total_fresh_ids({["3-5", "10-14", "16-20", "12-18"], []})
      14

      iex> Year2025.Day5.count_total_fresh_ids({["1-5", "3-7"], []})
      7
  """
  @spec count_total_fresh_ids(raw_input()) :: non_neg_integer()
  def count_total_fresh_ids({raw_ranges, _ids}) do
    raw_ranges
    |> build_and_condense_ranges()
    |> Enum.reduce(0, fn range, acc -> acc + Range.size(range) end)
  end

  @spec in_ranges?(non_neg_integer(), tuple()) :: boolean()
  defp in_ranges?(id, ranges), do: binary_search(id, ranges, 0, tuple_size(ranges) - 1)

  @spec binary_search(non_neg_integer(), tuple(), integer(), integer()) :: boolean()
  defp binary_search(_id, _ranges, low, high) when low > high, do: false

  defp binary_search(id, ranges, low, high) do
    mid = div(low + high, 2)
    range = elem(ranges, mid)

    cond do
      id < range.first -> binary_search(id, ranges, low, mid - 1)
      id > range.last -> binary_search(id, ranges, mid + 1, high)
      true -> true
    end
  end

  @spec build_and_condense_ranges([String.t()]) :: [Range.t()]
  defp build_and_condense_ranges(raw_ranges) do
    raw_ranges
    |> Enum.map(&parse_range!/1)
    |> Enum.sort_by(& &1.first)
    |> condense_ranges()
  end

  @spec parse_range!(String.t()) :: Range.t()
  defp parse_range!(s) do
    [a_str, b_str] = String.split(s, "-")
    Range.new(String.to_integer(a_str), String.to_integer(b_str))
  end

  @spec condense_ranges([Range.t()]) :: [Range.t()]
  defp condense_ranges([first | rest]), do: condense_ranges(rest, [first]) |> Enum.reverse()
  defp condense_ranges([], acc), do: acc

  defp condense_ranges([r | rs], [acc_head | acc_tail] = acc) do
    if r.first <= acc_head.last + 1 do
      merged = Range.new(acc_head.first, max(acc_head.last, r.last))
      condense_ranges(rs, [merged | acc_tail])
    else
      condense_ranges(rs, [r | acc])
    end
  end
end
