# Advent of Code Solutions

![Build Status](https://github.com/Elixir-journey/advent-of-code/actions/workflows/ci.yml/badge.svg)
![Elixir](https://img.shields.io/badge/elixir-1.19-purple)
![License](https://img.shields.io/github/license/Elixir-journey/advent-of-code)

My solutions to [Advent of Code](https://adventofcode.com/) challenges, implemented in Elixir.

## Project Structure
```
lib/
├── year_YYYY/
│   └── day_N.ex        # Solutions for each day
├── infrastructure/     # Shared utilities
│   ├── common_helpers.ex
│   └── input_file_loader.ex
└── mix/tasks/          # Custom mix tasks
    ├── setup_day_challenge.ex
```

## Getting Started

### Development Setup

#### Auto-Formatting, Linting, and Error Reporting
This project includes a set of tools to ensure code quality and consistency. These tools are configured to run automatically on save, giving you immediate feedback as you work.

1. Code formatting with [Elixir Formatter](https://hexdocs.pm/mix/main/Mix.Tasks.Format.html)

It ensures any code follows a consistent style. The Elixir Formatter is set to run automatically on save, formatting your code to follow standard Elixir conventions.

The .formatter.exs file controls settings, and auto-formatting is enabled in .vscode/settings.json.

2. Linting with [Credo](https://hexdocs.pm/credo/overview.html)

It enforces best practices and code consistency by highlighting potential readability and maintainability issues. Credo runs automatically on save through ElixirLS, displaying warnings and suggestions directly in the editor. You can also run ```mix credo``` in the terminal for a complete linting check.

3. Type Checking and Error Reporting with [Dialyzer](https://www.erlang.org/doc/apps/dialyzer/dialyzer_chapter.html)

It analyzes code for type errors and potential bugs, offering an additional layer of safety. Dialyzer is integrated with ElixirLS, running in the background and reporting issues as you work.
The initial setup may take a few minutes, as it builds a PLT (Persistent Lookup Table) with necessary type information.

### Development with Dev Containers

**Requirements:**
- [Docker](https://www.docker.com)
- [Visual Studio Code](https://code.visualstudio.com)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

1. Open the project in VS Code
2. Select "Reopen in Container" when prompted (or use Command Palette: `Dev Containers: Reopen in Container`)
3. Dependencies install automatically via `postCreateCommand`

### Running Locally (without Dev Containers)

Requires [Elixir 1.19+](https://elixir-lang.org/install.html) with OTP 28.
```bash
mix deps.get
```

## Usage

### Scaffold a New Day
```bash
mix setup_day_challenge 2025 1
```

Creates `lib/year_2025/day_1.ex` and `lib/year_2025/inputs/day_1/input.txt`.

## License

See [LICENSE](LICENSE) for details.
