defmodule Infrastructure.InputFileLoader do
  @moduledoc """
  A utility module for reading input files for Advent of Code challenges.
  """

  @doc """
  Reads the file at the given `file_path` and parses its content into lines, splitting each line into columns.

  ## Options

    - `regex`: The regex used to split each line into columns (default: whitespace).
    - `split_separator`: The string used to split the text into lines (default: `"\n"`).

  Returns `{:ok, parsed_lines}` if successful, or `{:error, reason}` for any errors.

  ## Examples
    # Example with an invalid file path
    iex> File.write!("test/file_samples/one_line.txt", "Hello\nWorld!\n")
    :ok

    iex> Infrastructure.InputFileLoader.get_parsed_lines("test/file_samples/one_line.txt")
    {:ok, [["Hello"], ["World!"]]}

    # Example with an invalid file path
    iex> Infrastructure.InputFileLoader.get_parsed_lines("non_existent.txt")
    {:error, :enoent}
  """
  @spec get_parsed_lines(binary(), Regex.t(), String.t()) ::
          {:ok, list(list(binary()))} | {:error, any()}
  def get_parsed_lines(file_path, regex \\ ~r/\s+/, split_separator \\ "\n")

  def get_parsed_lines(file_path, regex, split_separator) when is_binary(file_path) do
    case read_input(file_path) do
      {:ok, content} -> extract_lines_from_text(content, regex, split_separator)
      {:error, reason} -> {:error, reason}
    end
  end

  def get_parsed_lines(_, _, _) do
    {:error, "Invalid input. Expected a valid file path as a binary string."}
  end

  @doc """
  Reads the input file at the given `file_path` and returns its content as a string.

  Returns `{:ok, content}` if successful, or `{:error, reason}` if the file cannot be read.

  ## Examples

      # Example with a valid file
      iex> File.write!("test/file_samples/one_line.txt", "Hello, World!")
      :ok
      iex> Infrastructure.InputFileLoader.read_input("test/file_samples/one_line.txt")
      {:ok, "Hello, World!"}

      # Example with an invalid file path
      iex> Infrastructure.InputFileLoader.read_input("non_existent.txt")
      {:error, :enoent}

      # Example with invalid input type
      iex> Infrastructure.InputFileLoader.read_input(123)
      {:error, "Invalid file path. Please provide a valid binary string representing the file path."}
  """
  @spec read_input(binary()) :: {:ok, binary()} | {:error, any()}
  def read_input(file_path) when is_binary(file_path) do
    case File.read(file_path) do
      {:ok, content} -> {:ok, content}
      {:error, reason} -> {:error, reason}
    end
  end

  def read_input(_) do
    {:error,
     "Invalid file path. Please provide a valid binary string representing the file path."}
  end

  @doc """
  Parses text into lines, splitting each line into columns using a regex (default: whitespace).

  Returns `{:ok, parsed_lines}` if successful, or `{:error, reason}` for invalid input.

  ## Options

    - `split_separator`: The string used to split the text into lines (default: `"\n"`).
    - `regex`: The regex used to split each line into columns (default: whitespace).

  ## Examples

      iex> text = "1 2\\n3 4\\n"
      iex> Infrastructure.InputFileLoader.extract_lines_from_text(text)
      {:ok, [["1", "2"], ["3", "4"]]}

      iex> text = "a,b\\nc,d\\n"
      iex> Infrastructure.InputFileLoader.extract_lines_from_text(text, ~r/,/)
      {:ok, [["a", "b"], ["c", "d"]]}

      iex> text = "1;2;3|4;5;6"
      iex> Infrastructure.InputFileLoader.extract_lines_from_text(text, ~r/;/, "|")
      {:ok, [["1", "2", "3"], ["4", "5", "6"]]}

      iex> Infrastructure.InputFileLoader.extract_lines_from_text(123)
      {:error, "Invalid input. Expected a binary string for text and split_separator."}
  """
  @spec extract_lines_from_text(binary(), Regex.t(), String.t()) ::
          {:ok, list(list(binary()))} | {:error, any()}
  def extract_lines_from_text(text, regex \\ ~r/\s+/, split_separator \\ "\n")

  def extract_lines_from_text(text, regex, split_separator)
      when is_binary(text) and is_struct(regex, Regex) and is_binary(split_separator) do
    {:ok,
     text
     |> String.split(split_separator, trim: true)
     |> Enum.map(&String.split(&1, regex, trim: true))}
  end

  def extract_lines_from_text(_, _, _) do
    {:error, "Invalid input. Expected a binary string for text and split_separator."}
  end
end
