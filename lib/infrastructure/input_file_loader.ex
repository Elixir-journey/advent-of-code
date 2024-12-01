defmodule Infrastructure.InputFileLoader do
  @moduledoc """
  A utility module for reading input files for Advent of Code challenges.
  """

  @doc """
  Reads the input file at the given `file_path` and returns its content
  as a list of strings, split by line.

  ## Examples

      iex> CodeAdvent.Infrastructure.InputFileLoader.read_input("input.txt")
      ["line1", "line2", "line3"]

  Returns `{:error, reason}` if the file cannot be read.

  ## Error handling**:
  - The `File.read/1` function returns `{:ok, content}` or `{:error, reason}`, but the pipeline assumes success.
  If the file cannot be read, this will fail unexpectedly. Consider handling the `File.read/1` result explicitly.
  """
  def read_input(file_path) when is_binary(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content |> String.split("\n", trim: true)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def read_input(_) do
    {:error, "Invalid file path. Expected a binary string."}
  end
end
