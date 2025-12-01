defmodule Mix.Tasks.Day.Run do
  @moduledoc """
  Usage: mix day.run <number> < 1 | 2 >
         mix day.run <number> (runs both problems)
  """
  @shortdoc "Run the code for a given day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case OptionParser.parse!(args, strict: []) do
      {_opts, [day]} ->
        case find_module(day) do
          {:ok, module} ->
            time_a = run_problem(module, :problem_one)
            time_b = run_problem(module, :problem_two)

            Mix.shell().info("Total time: #{format_seconds(time_a + time_b)} seconds")

          {:error, reason} ->
            Mix.shell().error("Module for #{day} not found: #{reason}")
        end

      {_opts, [day, part]} when part in ["1", "2"] ->
        case find_module(day) do
          {:ok, module} -> run_problem(module, part)
          {:error, reason} -> Mix.shell().error("Module for #{day} not found: #{reason}")
        end

      _ ->
        Mix.shell().error("Invalid arguments. Usage: mix day.run <number> < 1 | 2 >")
    end
  end

  defp run_problem(module, "1"), do: run_problem(module, :problem_one)
  defp run_problem(module, "2"), do: run_problem(module, :problem_two)

  defp run_problem(module, function_name) do
    if function_exported?(module, function_name, 1) do
      {time_us, result} = :timer.tc(fn -> apply(module, function_name, []) end)

      Mix.shell().info("Running #{function_name}/1:\n\n#{inspect(result)}")
      Mix.shell().info("\nFinished in #{format_seconds(time_us)} seconds\n")
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
    :erlang.float_to_binary(us / 100_000, decimals: 4)
  end
end
