defmodule Mix.Tasks.RunDayChallenge do
  @moduledoc """
  Runs an Advent of Code solution with timing.

  ## Usage

      mix run_day_challenge <year> <day>          # Run both parts
      mix run_day_challenge <year> <day> --part 1 # Run specific part

  ## Examples

      mix run_day_challenge 2024 1
      mix run_day_challenge 2024 1 --part 2

  ## Output

  Displays the result of each part along with execution time.
  """

  use Mix.Task

  import Mix.Tasks.AocHelpers, only: [validate_year: 1, validate_day: 2]

  @shortdoc "Runs an AoC solution with timing"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case parse_args(args) do
      {:ok, year, day, part} ->
        run_solution(year, day, part)

      {:error, message} ->
        Mix.shell().error(message)
        Mix.shell().info("\nUsage: mix run_day_challenge <year> <day> [--part <1|2>]")
    end
  end

  defp parse_args(args) do
    {opts, positional, _} = OptionParser.parse(args, strict: [part: :integer])

    case positional do
      [year_str, day_str] ->
        with {year, ""} <- Integer.parse(year_str),
             {day, ""} <- Integer.parse(day_str),
             :ok <- validate_year(year),
             :ok <- validate_day(year, day) do
          {:ok, year, day, opts[:part]}
        else
          :error -> {:error, "Invalid year or day format"}
          {:error, msg} -> {:error, msg}
        end

      _ ->
        {:error, "Expected year and day arguments"}
    end
  end

  defp run_solution(year, day, part) do
    module = module_name(year, day)

    case Code.ensure_compiled(module) do
      {:module, _} ->
        run_parts(module, year, day, part)

      {:error, reason} ->
        Mix.shell().error("Could not load module #{inspect(module)}: #{inspect(reason)}")
        Mix.shell().info("Have you created the solution file? Try: mix aoc.setup #{year} #{day}")
    end
  end

  defp run_parts(module, year, day, nil) do
    Mix.shell().info("Running Year #{year} Day #{day}\n")
    run_part(module, 1)
    run_part(module, 2)
  end

  defp run_parts(module, year, day, part) when part in [1, 2] do
    Mix.shell().info("Running Year #{year} Day #{day} Part #{part}\n")
    run_part(module, part)
  end

  defp run_parts(_module, _year, _day, part) do
    Mix.shell().error("Invalid part: #{part}. Must be 1 or 2.")
  end

  defp run_part(module, part_num) do
    function = String.to_atom("part_#{part_num}")

    if function_exported?(module, function, 0) do
      {time_microseconds, result} = :timer.tc(fn -> apply(module, function, []) end)
      time_ms = time_microseconds / 1000

      Mix.shell().info("Part #{part_num}: #{format_result(result)}")
      Mix.shell().info("  Time: #{format_time(time_ms)}\n")
    else
      Mix.shell().info("Part #{part_num}: not implemented\n")
    end
  end

  defp format_result(result) when is_binary(result), do: result
  defp format_result(result), do: inspect(result)

  defp format_time(ms) when ms < 1, do: "#{Float.round(ms * 1000, 2)} µs"
  defp format_time(ms) when ms < 1000, do: "#{Float.round(ms, 2)} ms"
  defp format_time(ms), do: "#{Float.round(ms / 1000, 2)} s"

  defp module_name(year, day) do
    Module.concat([:"Year#{year}", :"Day#{day}"])
  end
end
