defmodule Infrastructure.AocClient do
  @moduledoc """
  HTTP client for adventofcode.com
  """

  @base_url "https://adventofcode.com"
  @title_regex ~r/<h2>--- Day \d+: (?<title>.+?) ---<\/h2>/

  @title_regex ~r/<h2>--- Day \d+: (?<title>.+?) ---<\/h2>/

  @doc """
  Fetches the puzzle input for a given year and day.
  """
  @spec fetch_input(year :: pos_integer(), day :: pos_integer()) ::
          {:ok, String.t()} | {:error, String.t()}
  def fetch_input(year, day) do
    "/#{year}/day/#{day}/input"
    |> request()
    |> handle_api_response()
    |> trim_body()
  end

  @doc """
  Fetches the puzzle title for a given year and day.
  """
  @spec fetch_title(year :: pos_integer(), day :: pos_integer()) ::
          {:ok, String.t()} | {:error, String.t()}
  def fetch_title(year, day) do
    "/#{year}/day/#{day}"
    |> request()
    |> handle_api_response()
    |> extract_title(day)
  end

  defp handle_api_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_api_response({:ok, %{status: 400}}), do: {:error, "Puzzle not available yet"}
  defp handle_api_response({:ok, %{status: 404}}), do: {:error, "Puzzle not found"}
  defp handle_api_response({:ok, %{status: status}}), do: {:error, "HTTP #{status}"}
  defp handle_api_response({:error, reason}), do: {:error, reason}

  defp trim_body({:ok, body}), do: {:ok, String.trim(body)}
  defp trim_body(error), do: error

  defp request(path) do
    Tesla.get(client(), path)
  end

  defp client do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      {Tesla.Middleware.Headers, [{"cookie", "session=#{session_cookie()}"}]}
    ]

    adapter = Application.get_env(:tesla, :adapter)
    Tesla.client(middleware, adapter)
  end

  defp extract_title({:ok, body}, day) do
    case Regex.named_captures(@title_regex, body) do
      %{"title" => title} -> {:ok, title}
      _ -> {:ok, "Day #{day}"}
    end
  end

  defp extract_title(error, _day), do: error

  defp session_cookie do
    System.get_env("AOC_SESSION_COOKIE") ||
      File.read!(Path.join(File.cwd!(), ".aoc_session")) |> String.trim()
  end
end
