defmodule Mix.Tasks.Day.Run do
  @moduledoc """
  Usage: mix day.run <number> < 1 | 2 >
         mix day.run <number> (runs both parts)

  Note: this task starts the whole application so it can load
  runtime deps (Memoize)
  """
  @shortdoc "Run the code for a given day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: [readme: :boolean]) do
      {opts, [day]} ->
        case find_module(day) do
          {:ok, module} ->
            time_a = run_part(module, :part_one)
            time_b = run_part(module, :part_two)

            Mix.shell().info("---------------------------------------")
            Mix.shell().info("Total execution time: #{format_seconds(time_a + time_b)} seconds")

            if opts[:readme] do
              module_name = String.replace(inspect(module), "Elixir.", "")
              Mix.shell().info("---------------------------------------")
              Mix.shell().info("Readme table row:")

              Mix.shell().info(
                "\n| #{day} | #{module_name} | #{format_seconds(time_a + time_b)}s | ⭐⭐  |\n"
              )
            end

          {:error, reason} ->
            Mix.shell().error("Module for #{day} not found: #{reason}")
        end

      {_opts, [day, part]} when part in ["1", "2"] ->
        case find_module(day) do
          {:ok, module} -> run_part(module, part)
          {:error, reason} -> Mix.shell().error("Module for #{day} not found: #{reason}")
        end

      _ ->
        Mix.shell().error("Invalid arguments. Usage: mix day.run <number> < 1 | 2 >")
    end
  end

  defp run_part(module, "1"), do: run_part(module, :part_one)
  defp run_part(module, "2"), do: run_part(module, :part_two)

  defp run_part(module, function_name) do
    if function_exported?(module, function_name, 1) do
      module_name = String.replace(inspect(module), "Elixir.", "")
      Mix.shell().info("---------------------------------------")
      Mix.shell().info("Running #{module_name} #{function_name}/1:")

      {time_us, result} = :timer.tc(fn -> apply(module, function_name, [:input]) end)

      Mix.shell().info("\nResult: #{inspect(result)}")

      Mix.shell().info("\nFinished in #{format_seconds(time_us)} seconds")
      time_us
    else
      Mix.shell().error("Function #{function_name}/1 not found in module #{module}")
    end
  end

  defp find_module(day) do
    with {:ok, file_path} <- find_module_file("lib/day#{day}"),
         {:ok, module_name} <- extract_module_name(file_path),
         atom_module <- String.to_existing_atom("Elixir.#{module_name}"),
         {:module, module} <- Code.ensure_loaded(atom_module) do
      {:ok, module}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp find_module_file(day_path) do
    if File.dir?(day_path) do
      case Path.wildcard(Path.join(day_path, "*.ex")) do
        [file_path | _] -> {:ok, file_path}
        [] -> {:error, "No .ex files found in #{day_path}"}
      end
    else
      {:error, "Directory #{day_path} does not exist"}
    end
  end

  defp extract_module_name(file_path) do
    File.read!(file_path)
    |> Code.string_to_quoted()
    |> case do
      {:ok, {:defmodule, _, [{:__aliases__, _, module_parts}, _]}} ->
        {:ok, Enum.join(module_parts, ".")}

      _ ->
        {:error, "Could not extract module name from file"}
    end
  end

  defp format_seconds(us) do
    :erlang.float_to_binary(us / 1_000_000, decimals: 4)
  end
end
