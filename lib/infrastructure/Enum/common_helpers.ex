defmodule Infrastructure.Enum.CommonHelpers do
  @moduledoc """
  A collection of common helper functions for working with enumerables.

  Provides utilities for processing lists, maps, and other enumerable data structures.
  """

  @doc """
  Builds a frequency map from an enumerable.

  ## Options
    - `:default` - Default count for elements (default: `1`).

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map([1, 2, 2, 3, 3, 3])
      %{1 => 1, 2 => 2, 3 => 3}

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map(["a", "b", "a"], default: 0)
      %{"a" => 1, "b" => 0}
  """
  @spec build_frequency_map(Enumerable.t(), keyword()) :: map()
  def build_frequency_map(enumerable, opts \\ []) do
    default = Keyword.get(opts, :default, 1)

    Enum.reduce(enumerable, %{}, fn key, acc ->
      Map.update(acc, key, default, &(&1 + 1))
    end)
  end

  @doc """
  Converts a list of strings to a list of integers.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.convert_strings_to_integers(["1", "2", "3"])
      [1, 2, 3]
  """
  @spec convert_strings_to_integers([String.t()]) :: [integer()]
  def convert_strings_to_integers(strings), do: Enum.map(strings, &String.to_integer/1)

  @doc """
  Checks if all elements in an enumerable are strictly increasing.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.strictly_increasing?([1, 2, 3])
      true

      iex> Infrastructure.Enum.CommonHelpers.strictly_increasing?([1, 2, 2])
      false
  """
  @spec strictly_increasing?(Enumerable.t()) :: boolean()
  def strictly_increasing?(enumerable), do: monotonic?(enumerable, &</2)

  @doc """
  Checks if all elements in an enumerable are strictly decreasing.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.strictly_decreasing?([3, 2, 1])
      true

      iex> Infrastructure.Enum.CommonHelpers.strictly_decreasing?([3, 2, 2])
      false
  """
  @spec strictly_decreasing?(Enumerable.t()) :: boolean()
  def strictly_decreasing?(enumerable), do: monotonic?(enumerable, &>/2)

  @doc """
  Checks if adjacent values in an enumerable fall within a specified range.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.adjacent_values_in_range?([1, 3, 5], 1, 3)
      true

      iex> Infrastructure.Enum.CommonHelpers.adjacent_values_in_range?([1, 13, 45], 1, 3)
      false
  """
  @spec adjacent_values_in_range?(Enumerable.t(), number(), number()) :: boolean()
  def adjacent_values_in_range?(levels, min, max) do
    levels
    |> pairwise()
    |> Enum.all?(fn {a, b} -> in_range?(abs(a - b), min, max) end)
  end

  @doc """
  Generates pairs of adjacent elements from an enumerable.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.pairwise([1, 2, 3])
      [{1, 2}, {2, 3}]
  """
  @spec pairwise(Enumerable.t()) :: [{any(), any()}]
  def pairwise(enumerable) do
    enumerable
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> {a, b} end)
  end

  # Helper function for monotonic checks
  defp monotonic?(enumerable, comparator) do
    pairwise(enumerable)
    |> Enum.all?(fn {a, b} -> comparator.(a, b) end)
  end

  defp in_range?(value, min, max), do: value >= min and value <= max
end
