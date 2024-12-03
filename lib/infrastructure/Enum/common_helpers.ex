defmodule Infrastructure.Enum.CommonHelpers do
  @moduledoc """
  A collection of common helper functions for working with enumerables.

  This module provides utilities for processing lists, maps, and other enumerable data structures.
  """

  @doc """
  Builds a frequency map from an enumerable, with customizable options.

  Given a list of elements, this function returns a map where the keys are the elements
  of the list, and the values are the number of times each element appears in the list.
  The default count for elements not present in the enumerable can be specified via options.

  ## Options

    - `:default` - The default value to use for keys that are not incremented (default: `1`).

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map([1, 2, 2, 3, 3, 3])
      %{1 => 1, 2 => 2, 3 => 3}

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map(["a", "b", "a", "c", "a", "b"])
      %{"a" => 3, "b" => 2, "c" => 1}

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map([], default: 0)
      %{}

      iex> Infrastructure.Enum.CommonHelpers.build_frequency_map([:x, :y, :x], default: 0)
      %{x: 1, y: 0}

  ## Parameters

    - `array`: An enumerable containing elements for which to calculate frequencies.

  ## Returns

    - A map where each key is an element from the input enumerable, and each value is the count of that element.
  """
  @spec build_frequency_map(Enumerable.t(), keyword()) :: map()
  def build_frequency_map(array, opts \\ []) do
    default = Keyword.get(opts, :default, 1)

    Enum.reduce(array, %{}, fn key, acc ->
      Map.update(acc, key, default, &(&1 + 1))
    end)
  end

  @doc """
  Converts a list of strings to a list of integers.

  ## Examples

      iex> Infrastructure.Enum.CommonHelpers.convert_strings_to_integers(["1", "2", "3"])
      [1, 2, 3]

      iex> Infrastructure.Enum.CommonHelpers.convert_strings_to_integers([])
      []
  """
  @spec convert_strings_to_integers([String.t()]) :: [integer()]
  def convert_strings_to_integers(strings) do
    Enum.map(strings, &String.to_integer/1)
  end

  @doc """
  Checks if all elements in the enumerable are strictly increasing.

  A strictly increasing enumerable means that for every adjacent pair of elements,
  the second element is greater than the first.

  ## Parameters
    - `enumerable`: A list or any enumerable containing comparable elements.

  ## Returns
    - `true` if the enumerable is strictly increasing.
    - `false` otherwise.

  ## Examples

      iex> strictly_increasing?([1, 2, 3, 4])
      true

      iex> strictly_increasing?([1, 2, 2, 3])
      false
  """
  def strictly_increasing?(enumerable) do
    enumerable
    # Creates overlapping pairs
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a < b end)
  end

  @doc """
  Checks if all elements in the enumerable are strictly decreasing.

  A strictly decreasing enumerable means that for every adjacent pair of elements,
  the second element is less than the first.

  ## Parameters
    - `enumerable`: A list or any enumerable containing comparable elements.

  ## Returns
    - `true` if the enumerable is strictly decreasing.
    - `false` otherwise.

  ## Examples

      iex> strictly_decreasing?([5, 4, 3, 2, 1])
      true

      iex> strictly_decreasing?([5, 4, 4, 2, 1])
      false
  """
  def strictly_decreasing?(enumerable) do
    enumerable
    # Creates overlapping pairs
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a > b end)
  end

  @doc """
  Checks if the absolute difference between adjacent values in the enumerable
  falls within the specified range.

  This function ensures that for every pair of adjacent values, the difference
  is at least `min_diff` and at most `max_diff`.

  ## Parameters
    - `levels`: A list or enumerable of numbers.
    - `min_diff`: The minimum allowable difference between adjacent values.
    - `max_diff`: The maximum allowable difference between adjacent values.

  ## Returns
    - `true` if all adjacent differences are within the range.
    - `false` otherwise.

  ## Examples

      iex> adjacent_values_in_range?([1, 3, 5, 7], 1, 3)
      true

      iex> adjacent_values_in_range?([1, 3, 6, 10], 1, 3)
      false

      iex> adjacent_values_in_range?([], 1, 3)
      true # Empty lists are trivially valid.
  """
  def adjacent_values_in_range?(levels, min_diff, max_diff) do
    Enum.chunk_every(levels, 2, 1, :discard)
    |> Enum.all?(fn [a, b] ->
      diff = abs(b - a)
      diff >= min_diff and diff <= max_diff
    end)
  end
end
