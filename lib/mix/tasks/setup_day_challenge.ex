defmodule Mix.Tasks.SetupDayChallenge do
  @moduledoc """
  Sets up a new Advent of Code day with all necessary files.

  ## Usage

      mix setup_day_challenge YEAR DAY

  ## Examples

      mix setup_day_challenge 2025 1
      mix setup_day_challenge 2024 12

  ## What it creates

  - `lib/year_YEAR/day_DAY.ex` - Solution module with template
  - `lib/inputs/YEAR/day_DAY/input.txt` - Puzzle input (fetched from AoC)
  - `test/year_YEAR/day_DAY_test.exs` - Test file with sample structure

  ## Requirements

  Session cookie must be available via:
  - AOC_SESSION_COOKIE environment variable, or
  - .aoc_session file in project root
  """

  use Mix.Task

  alias Infrastructure.Http.AocClient
  import Mix.Tasks.AocHelpers

  @shortdoc "Sets up a new Advent of Code day"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case parse_args(args) do
      {:ok, year, day} ->
        setup_day(year, day)

      {:error, message} ->
        Mix.shell().error(message)
        Mix.shell().info("\nUsage: mix setup_day_challenge YEAR DAY")
        Mix.shell().info("Example: mix setup_day_challenge 2025 1")
    end
  end

  defp setup_day(year, day) do
    Mix.shell().info("Setting up Year #{year}, Day #{day}...")

    with {:ok, title} <- fetch_title(year, day),
         {:ok, input} <- fetch_input(year, day),
         :ok <- create_solution_module(year, day, title),
         :ok <- create_input_file(year, day, input),
         :ok <- create_test_file(year, day, title) do
      handle_setup_created(day, year, title)
    else
      {:error, message} ->
        Mix.shell().error("Setup failed: #{message}")
    end
  end

  defp handle_setup_created(day, year, title) do
    Mix.shell().info("""

    Setup complete for Day #{day}: #{title}

    Created:
      • lib/year_#{year}/day_#{day}.ex
      • lib/inputs/#{year}/day_#{day}/input.txt
      • test/year_#{year}/day_#{day}_test.exs

    Next steps:
      1. Read the puzzle at https://adventofcode.com/#{year}/day/#{day}
      2. Implement your solution in lib/year_#{year}/day_#{day}.ex
      3. Run with: mix run_day_challenge #{year} #{day}
    """)
  end

  defp fetch_title(year, day) do
    Mix.shell().info("  Fetching puzzle title...")
    AocClient.fetch_title(year, day)
  end

  defp fetch_input(year, day) do
    Mix.shell().info("  Fetching puzzle input...")
    AocClient.fetch_input(year, day)
  end

  defp create_solution_module(year, day, title) do
    dir = "lib/year_#{year}"
    path = "#{dir}/day_#{day}.ex"

    if File.exists?(path) do
      Mix.shell().info("  Solution module already exists, skipping...")
      :ok
    else
      File.mkdir_p!(dir)
      File.write!(path, solution_template(year, day, title))
      Mix.shell().info("  Created solution module")
      :ok
    end
  end

  defp create_input_file(year, day, input) do
    dir = "lib/inputs/#{year}/day_#{day}"
    File.mkdir_p!(dir)

    File.write!("#{dir}/input.txt", input)
    Mix.shell().info("  Created input file")
    :ok
  end

  defp create_test_file(year, day, title) do
    dir = "test/year_#{year}"
    path = "#{dir}/day_#{day}_test.exs"

    if File.exists?(path) do
      Mix.shell().info("  Test file already exists, skipping...")
      :ok
    else
      File.mkdir_p!(dir)
      File.write!(path, test_template(year, day, title))
      Mix.shell().info("  Created test file")
      :ok
    end
  end

  defp solution_template(year, day, title) do
    """
    defmodule Year#{year}.Day#{day} do
      @moduledoc \"\"\"
      --- Day #{day}: #{title} ---

      ## Part 1
      ### Summarize what you need to achieve.

      ## Part 2
      ### Summarize what you need to achieve.
      \"\"\"

      @data_path "lib/inputs/#{year}/day_#{day}/input.txt"

      alias Infrastructure.FileIO.InputFileLoader

      @doc \"\"\"
      Solves Part 1.
      \"\"\"
      def part_1, do: solve(@data_path, &solve_part_1/1)

      @doc \"\"\"
      Solves Part 2.
      \"\"\"
      def part_2, do: solve(@data_path, &solve_part_2/1)

      defp solve(path, solver) do
        path
        |> load_input()
        |> solver.()
      end

      defp load_input(path) do
        with {:ok, content} <- InputFileLoader.read_input(path) do
          parse_input(content)
        else
          {:error, reason} -> raise "Failed to read input: \#{reason}"
        end
      end

      @doc \"\"\"
      Parses the raw input into a usable data structure.
      \"\"\"
      def parse_input(content) do
        content
        |> String.trim()
        |> String.split("\\n")
        # TODO: Add parsing logic
      end

      @doc \"\"\"
      Solves Part 1 with the parsed input.
      \"\"\"
      def solve_part_1(input) do
        # TODO: Implement
        input
        |> length()
      end

      @doc \"\"\"
      Solves Part 2 with the parsed input.
      \"\"\"
      def solve_part_2(input) do
        # TODO: Implement
        input
        |> length()
      end
    end
    """
  end

  defp test_template(year, day, title) do
    """
    defmodule Year#{year}.Day#{day}Test do
      use ExUnit.Case, async: true

      alias Year#{year}.Day#{day}

      @sample_input \"\"\"
      [paste sample input here]
      \"\"\"

      describe "Day #{day}: #{title}" do
        test "parse_input/1 parses sample input" do
          parsed = Day#{day}.parse_input(@sample_input)
          assert is_list(parsed)
        end

        @tag :part_1
        test "part 1 with sample input" do
          result =
            @sample_input
            |> Day#{day}.parse_input()
            |> Day#{day}.solve_part_1()

          assert result == :expected_value
        end

        @tag :part_2
        test "part 2 with sample input" do
          result =
            @sample_input
            |> Day#{day}.parse_input()
            |> Day#{day}.solve_part_2()

          assert result == :expected_value
        end

        @tag :solution
        test "part 1 solution" do
          assert Day#{day}.part_1() == :your_answer
        end

        @tag :solution
        test "part 2 solution" do
          assert Day#{day}.part_2() == :your_answer
        end
      end
    end
    """
  end
end
