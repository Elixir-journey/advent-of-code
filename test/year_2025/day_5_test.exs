defmodule Year2025.Day5Test do
  use ExUnit.Case, async: true

  alias Year2025.Day5

  @sample_input """
  [paste sample input here]
  """

  describe "Day 5: Cafeteria" do
    test "parse_input/1 parses sample input" do
      parsed = Day5.parse_input(@sample_input)
      assert is_list(parsed)
    end

    @tag :part_1
    test "part 1 with sample input" do
      result =
        @sample_input
        |> Day5.parse_input()
        |> Day5.solve_part_1()

      assert result == :expected_value
    end

    @tag :part_2
    test "part 2 with sample input" do
      result =
        @sample_input
        |> Day5.parse_input()
        |> Day5.solve_part_2()

      assert result == :expected_value
    end

    @tag :solution
    test "part 1 solution" do
      assert Day5.part_1() == :your_answer
    end

    @tag :solution
    test "part 2 solution" do
      assert Day5.part_2() == :your_answer
    end
  end
end
