defmodule Year2025.Day5Test do
  use ExUnit.Case, async: true

  alias Year2025.Day5

  @sample_input """
  3-5
  10-14
  16-20
  12-18

  3 7 12 20
  """

  describe "Day 5: Cafeteria" do
    test "parse_ingredient_id_from_text/1 parses sample input" do
      {ranges, ids} = Day5.parse_ingredient_id_from_text(@sample_input)

      assert ranges == ["3-5", "10-14", "16-20", "12-18"]
      assert ids == [3, 7, 12, 20]
    end

    @tag :part_1
    test "part 1 with sample input" do
      result =
        @sample_input
        |> Day5.parse_ingredient_id_from_text()
        |> Day5.count_all_fresh_ingredients_left()

      # 3 is in 3-5, 7 is not in any range, 12 is in 10-14 and 12-18, 20 is in 16-20
      assert result == 3
    end

    @tag :part_2
    test "part 2 with sample input" do
      result =
        @sample_input
        |> Day5.parse_ingredient_id_from_text()
        |> Day5.count_total_fresh_ids()

      # Condensed: 3..5 (3) + 10..20 (11) = 14 unique IDs
      assert result == 14
    end

    @tag :solution
    test "part 1 solution" do
      assert Day5.part_1() == 885
    end

    @tag :solution
    test "part 2 solution" do
      assert Day5.part_2() == 348_115_621_205_535
    end
  end
end
