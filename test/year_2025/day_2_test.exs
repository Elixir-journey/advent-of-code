defmodule Year2025.Day2Test do
  use ExUnit.Case, async: true

  alias Year2025.Day2

  @sample_input "95-115,11-22,998-1012"

  describe "Day 2: Gift Shop" do
    test "parse_input/1 parses sample input" do
      parsed = Day2.parse_input(@sample_input)
      assert is_list(parsed)
    end

    @tag :part_1
    test "part 1 with sample input" do
      result =
        @sample_input
        |> Day2.parse_input()
        |> Day2.solve_part_1()

      assert result == 1142
    end

    @tag :part_2
    test "part 2 with sample input" do
      result =
        @sample_input
        |> Day2.parse_input()
        |> Day2.solve_part_2()

      assert result == 2252
    end

    @tag :solution
    test "part 1 solution" do
      assert Day2.part_1() == 44_854_383_294
    end

    @tag :solution
    test "part 2 solution" do
      assert Day2.part_2() == 55_647_141_923
    end
  end
end
