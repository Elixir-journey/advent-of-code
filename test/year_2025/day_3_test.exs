defmodule Year2025.Day3Test do
  use ExUnit.Case, async: true

  alias Year2025.Day3

  @sample_input """
  [paste sample input here]
  """

  describe "Day 3: Lobby" do
    test "parse_input/1 parses sample input" do
      parsed = Day3.parse_input(@sample_input)
      assert is_list(parsed)
    end

    @tag :part_1
    test "part 1 with sample input" do
      result =
        @sample_input
        |> Day3.parse_input()
        |> Day3.solve_part_1()

      assert result == :expected_value
    end

    @tag :part_2
    test "part 2 with sample input" do
      result =
        @sample_input
        |> Day3.parse_input()
        |> Day3.solve_part_2()

      assert result == :expected_value
    end

    @tag :solution
    test "part 1 solution" do
      assert Day3.part_1() == :your_answer
    end

    @tag :solution
    test "part 2 solution" do
      assert Day3.part_2() == :your_answer
    end
  end
end
