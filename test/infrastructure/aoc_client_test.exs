defmodule Infrastructure.AocClientTest do
  use ExUnit.Case, async: false

  alias Infrastructure.AocClient

  # These hit real AoC - skip in CI, run manually
  @moduletag :integration

  describe "fetch_input/2" do
    test "returns input for valid day" do
      {:ok, input} = AocClient.fetch_input(2024, 1)
      assert String.length(input) > 0
    end

    test "returns error for non-existent day" do
      assert {:error, _} = AocClient.fetch_input(2024, 99)
    end
  end

  describe "fetch_title/2" do
    test "extracts title from page" do
      assert {:ok, "Historian Hysteria"} = AocClient.fetch_title(2024, 1)
    end

    test "returns error for non-existent day" do
      assert {:error, _} = AocClient.fetch_title(2024, 99)
    end
  end
end
