# test/elixir_kickoff_application_test.exs
defmodule AdventOfCodeApplicationTest do
  use ExUnit.Case

  @moduledoc """
  Tests for the AdventOfCode.Application module.
  """

  test "ensures the application starts correctly" do
    # Ensure the application is started, starting it only if necessary
    case Application.ensure_all_started(:adventofcode) do
      {:ok, _apps} -> assert true
      {:error, {:already_started, _app}} -> assert true
    end
  end
end
