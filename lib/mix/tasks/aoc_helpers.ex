defmodule Mix.Tasks.AocHelpers do
  @moduledoc false
  def parse_args([year_str, day_str]) do
    with {year, ""} <- Integer.parse(year_str),
         {day, ""} <- Integer.parse(day_str),
         :ok <- validate_year(year),
         :ok <- validate_day(year, day) do
      {:ok, year, day}
    else
      _ -> {:error, "Invalid arguments. Year and day must be valid integers."}
    end
  end

  def parse_args(_), do: {:error, "Expected 2 arguments: YEAR DAY"}

  @first_year 2015
  @current_year 2025
  def validate_year(year) when year >= @first_year and year <= @current_year, do: :ok
  def validate_year(_), do: {:error, "Year must be between #{@first_year} and #{@current_year}"}

  @full_advent_years 2015..2024
  def validate_day(year, day) do
    cond do
      day < 1 ->
        {:error, "Day must be at least 1."}

      day > 25 ->
        {:error, "Day cannot exceed 25."}

      day > 12 and year not in @full_advent_years ->
        {:error, "#{year} only has challenges through December 12th."}

      true ->
        :ok
    end
  end
end
