defmodule Mix.Tasks.Day.Run do
  @moduledoc """
  Usage: mix day.run all
         mix day.run <number> < 1 | 2 >
         mix day.run <number> (runs both parts)

  Flags: --readme: print timing log for readme
         --sample: run sample inputs

  Note: this task starts the whole application so it can load
  runtime deps (Memoize)
  """
  @shortdoc "Run the code for a given day(s)"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: [readme: :boolean, input: :string]) do
      {opts, ["all"]} ->
        Mix.shell().info("---------------------------------------")

        case opts[:input] do
          "input" ->
            Enum.map(1..12, &run_day(&1, :input))

          "sample" ->
            Enum.map(1..12, &run_day(&1, :sample))

          _ ->
            Enum.map(1..12, fn i ->
              run_day(i, :sample)
              run_day(i, :input)
            end)
        end

        Mix.shell().info("---------------------------------------")

      {opts, [day]} ->
        case find_module(day) do
          {:ok, module} ->
            module_name = String.replace(inspect(module), "Elixir.", "")
            input = if opts[:input] == "sample", do: :sample, else: :input

            {time_a, _result_a} = run_part(module, :part_one, input, true)
            {time_b, _result_b} = run_part(module, :part_two, input, true)
            Mix.shell().info("---------------------------------------")

            if opts[:readme] do
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
          {:ok, module} -> run_part(module, part, :input, true)
          {:error, reason} -> Mix.shell().error("Module for #{day} not found: #{reason}")
        end

        Mix.shell().info("---------------------------------------")

      _ ->
        Mix.shell().error("Invalid arguments. Usage: mix day.run <number> < 1 | 2 >")
    end
  end

  def run_day(day, input) do
    case find_module(day) do
      {:ok, module} ->
        {time_a, _} = run_part(module, :part_one, input, false)
        {time_b, _} = run_part(module, :part_two, input, false)

        module_name = String.replace(inspect(module), "Elixir.", "")
        sample = if input == :sample, do: "(sample)", else: ""

        Mix.shell().info(
          "| #{String.pad_trailing(inspect(day), 2)} | #{String.pad_trailing(module_name, 20)} #{String.pad_trailing(sample, 8)} | #{format_seconds(time_a + time_b)}s |"
        )

      {:error, reason} ->
        Mix.shell().error("Module for #{day} not found: #{reason}")
    end
  end

  defp run_part(module, "1", input_type, print),
    do: run_part(module, :part_one, input_type, print)

  defp run_part(module, "2", input_type, print),
    do: run_part(module, :part_two, input_type, print)

  defp run_part(module, function_name, input_type, print) do
    if function_exported?(module, function_name, 1) do
      module_name = String.replace(inspect(module), "Elixir.", "")

      {time, result} = :timer.tc(fn -> apply(module, function_name, [input_type]) end)

      if print do
        Mix.shell().info("---------------------------------------")
        Mix.shell().info("Running #{module_name} #{function_name}/1:")
        Mix.shell().info("\nResult: #{inspect(result)}")
        Mix.shell().info("\nFinished in #{format_seconds(time)} seconds")
      end

      {time, result}
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
