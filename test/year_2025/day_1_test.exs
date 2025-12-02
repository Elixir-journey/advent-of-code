defmodule Year2025.Day1Test do
  use ExUnit.Case, async: true
  doctest Year2025.Day1

  alias Year2025.Day1

  @sample_input """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  describe "parse/1" do
    test "parses L as negative, R as positive" do
      assert Day1.parse("L10\nR5\nL100") == [-10, 5, -100]
    end

    test "parses sample input" do
      assert Day1.parse(@sample_input) == [-68, -30, 48, -5, 60, -55, -1, -99, 14, -82]
    end
  end

  describe "door_lock_combination_code/1" do
    test "counts zeros with sample input" do
      assert Day1.door_lock_combination_code(@sample_input) == 3
    end

    test "returns 0 when dial never lands on 0" do
      assert Day1.door_lock_combination_code("R1\nL1") == 0
    end

    test "counts landing on 0 from wrap-around" do
      # Start at 50, L55 -> 95, R5 -> 0
      assert Day1.door_lock_combination_code("L55\nR5") == 1
    end

    test "handles large rotations" do
      # Start at 50, R9950 -> 0 (9950 + 50 = 10000, mod 100 = 0)
      assert Day1.door_lock_combination_code("R9950") == 1
    end
  end

  describe "solutions" do
    @tag :solution
    test "part 1" do
      assert Day1.part_1() == 1011
    end
  end
end
