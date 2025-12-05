defmodule Year2025.Day3Test do
  use ExUnit.Case, async: true

  alias Year2025.Day3

  @sample_input """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  describe "Day 3: Lobby" do
    test "parse_battery_banks/1 parses sample input" do
      parsed = Day3.parse_battery_banks(@sample_input)
      assert is_list(parsed)
    end

    @tag :part_1
    test "part 1 with sample input" do
      result =
        @sample_input
        |> Day3.parse_battery_banks()
        |> Day3.maximum_joltage_for_battery_banks()

      assert result == 357
    end

    @tag :solution
    test "part 1 solution" do
      assert Day3.part_1() == 17207
    end
  end
end
