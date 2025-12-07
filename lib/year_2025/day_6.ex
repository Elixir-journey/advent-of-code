defmodule Year2025.Day6 do
  @moduledoc """
  --- Day 6: Trash Compactor ---

  ## Part 1
  Solve math problems arranged vertically in columns. Each column contains
  numbers to be added or multiplied (indicated by the operator at the bottom).
  Sum all the results.

  ## Part 2
  TODO
  """

  alias Infrastructure.FileIO.InputFileLoader

  @input_path "lib/inputs/2025/day_6/input.txt"

  # Public Solution APIs

  @spec part_1() :: non_neg_integer() | {:error, any()}
  def part_1 do
    case InputFileLoader.get_parsed_lines(@input_path) do
      {:ok, worksheet} -> compute_worksheet_grand_total(worksheet)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec part_2() :: non_neg_integer() | {:error, any()}
  def part_2 do
    case InputFileLoader.get_parsed_lines(@input_path) do
      {:ok, worksheet} -> solve_part_2(worksheet)
      {:error, reason} -> {:error, reason}
    end
  end

  # Domain Logic

  @doc """
  Computes the grand total by solving all problems on the worksheet.

  ## Examples

      iex> worksheet = [
      ...>   ["123", "328", "51", "64"],
      ...>   ["45", "64", "387", "23"],
      ...>   ["6", "98", "215", "314"],
      ...>   ["*", "+", "*", "+"]
      ...> ]
      iex> Year2025.Day6.compute_worksheet_grand_total(worksheet)
      4277556
  """
  @spec compute_worksheet_grand_total([[String.t()]]) :: non_neg_integer()
  def compute_worksheet_grand_total(worksheet) do
    worksheet
    |> transpose()
    |> Task.async_stream(&solve_problem/1,
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  @doc """
  Solves a single problem (column). The last element is the operator,
  the rest are numbers.

  ## Examples

      iex> Year2025.Day6.solve_problem(["123", "45", "6", "*"])
      33210

      iex> Year2025.Day6.solve_problem(["328", "64", "98", "+"])
      490
  """
  @spec solve_problem([String.t()]) :: non_neg_integer()
  def solve_problem(column) do
    [operator | reversed_numbers] = Enum.reverse(column)
    numbers = reversed_numbers |> Enum.map(&String.to_integer/1)

    apply_operation(operator, numbers)
  end

  defp apply_operation("*", numbers), do: Enum.product(numbers)
  defp apply_operation("+", numbers), do: Enum.sum(numbers)

  @doc """
  Transposes rows into columns.

  ## Examples

      iex> Year2025.Day6.transpose([["a", "b"], ["c", "d"]])
      [["a", "c"], ["b", "d"]]
  """
  @spec transpose([[any()]]) :: [[any()]]
  def transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def solve_part_2(input) do
    # TODO: Implement
    length(input)
  end
end
