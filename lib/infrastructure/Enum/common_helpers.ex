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
      %{x: 2, y: 1}

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
end
