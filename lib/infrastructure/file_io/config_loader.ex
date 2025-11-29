defmodule Infrastructure.FileIO.ConfigLoader do
  @moduledoc """
  Configuration helpers for the application.
  """

  @doc """
  Reads a file from the project root directory.
  """
  @spec read_root_file!(String.t()) :: String.t()
  def read_root_file!(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.read!()
    |> String.trim()
  end
end
