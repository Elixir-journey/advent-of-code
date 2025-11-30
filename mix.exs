defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :adventofcode,
      name: "AoC Solutions",
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :dev,
      deps: deps(),
      dialyzer: dialyzer(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {AdventOfCode.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.3"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1"},
      {:sobelow, "~> 0.13.0"},
      {:tesla, "~> 1.8"},
      {:hackney, "~> 1.18"}
    ]
  end

  defp dialyzer do
    [
      plt_add_deps: :app_tree,
      plt_add_apps: [:mix, :ex_unit]
    ]
  end
end
