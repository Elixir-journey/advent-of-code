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
    test "parse_battery_bank_voltage/1 parses sample input" do
      parsed = Day3.parse_battery_bank_voltage(@sample_input)

      assert parsed == [
               987_654_321_111_111,
               811_111_111_111_119,
               234_234_234_234_278,
               818_181_911_112_111
             ]
    end

    @tag :part_1
    test "part 1 with sample input" do
      result = Day3.maximum_joltage_for_battery_banks(@sample_input)

      assert result == 357
    end

    @tag :solution
    test "part 1 solution" do
      assert Day3.part_1() == 17_207
    end

    @tag :part_2
    test "part 2 with sample input" do
      result = Day3.maximum_joltage_for_battery_banks(@sample_input, 12)

      assert result == 3_121_910_778_619
    end

    @tag :solution
    test "part 2 solution" do
      assert Day3.part_2() == 170_997_883_706_617
    end
  end
end
