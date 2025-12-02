defmodule Year2025.Day1Test do
  use ExUnit.Case, async: true

  doctest Year2025.Day1

  import Year2025.Day1

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

  describe "count_landings_at_zero/1" do
    test "counts positions that land exactly on zero" do
      assert count_landings_at_zero(@sample_input) == 3
    end

    test "returns zero when no rotations land on zero" do
      input = "R10\nL5\nR3"
      assert count_landings_at_zero(input) == 0
    end

    test "handles single rotation landing on zero" do
      input = "R50"
      assert count_landings_at_zero(input) == 1
    end
  end

  describe "count_all_times_at_zero/1" do
    test "counts landings plus pass-throughs" do
      assert count_all_times_at_zero(@sample_input) == 6
    end

    test "counts multiple pass-throughs in large rotation" do
      input = "R250"
      assert count_all_times_at_zero(input) == 3
    end

    test "does not count starting position" do
      input = "L50\nL5"
      assert count_all_times_at_zero(input) == 1
    end
  end

  describe "count_zeros_in_rotation/2" do
    test "moving right, passes through zero" do
      assert count_zeros_in_rotation(95, 60) == 1
    end

    test "moving right, lands exactly on zero" do
      assert count_zeros_in_rotation(52, 48) == 1
    end

    test "moving right, does not reach zero" do
      assert count_zeros_in_rotation(50, 30) == 0
    end

    test "moving right, multiple crossings" do
      assert count_zeros_in_rotation(95, 205) == 3
    end

    test "moving left, passes through zero" do
      assert count_zeros_in_rotation(50, -68) == 1
    end

    test "moving left, does not reach zero" do
      assert count_zeros_in_rotation(82, -30) == 0
    end

    test "moving left, starting at zero does not count" do
      assert count_zeros_in_rotation(0, -5) == 0
    end

    test "moving left, starting at zero with full rotation" do
      assert count_zeros_in_rotation(0, -100) == 1
    end

    test "no movement" do
      assert count_zeros_in_rotation(50, 0) == 0
    end
  end

  describe "parse/1" do
    test "parses left rotations as negative" do
      assert parse("L10\nL25") == [-10, -25]
    end

    test "parses right rotations as positive" do
      assert parse("R10\nR25") == [10, 25]
    end

    test "parses mixed rotations" do
      assert parse("L68\nR30\nL5") == [-68, 30, -5]
    end

    test "handles trailing newline" do
      assert parse("L10\nR5\n") == [-10, 5]
    end
  end

  describe "dial_positions/1" do
    test "tracks positions after each rotation" do
      assert dial_positions([-68, -30, 48]) == [82, 52, 0]
    end

    test "wraps around correctly going right" do
      assert dial_positions([60]) == [10]
    end

    test "wraps around correctly going left" do
      assert dial_positions([-60]) == [90]
    end
  end

  describe "solutions" do
    @tag :solution
    test "part 1" do
      assert part_1() == 1011
    end

    @tag :solution
    test "part 2" do
      assert part_2() == 5937
    end
  end
end
