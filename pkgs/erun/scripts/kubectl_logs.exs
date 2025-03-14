# Print kubernetes pod group logs of the given 'app' argument.
#
# Usage:
# elixir kubectl_logs.exs --n=ddi --app=device-operation

defmodule KubectlLogs do
  defp cli_options(args) do
    with {options, _args, _} <-
           OptionParser.parse(args,
             switches: [n: :string, app: :string]
           ) do
      {:ok, options}
    else
      reason -> {:error, reason}
    end
  end

  def main() do
    {:ok, opts} = cli_options(System.argv())
    namespace = Keyword.get(opts, :n, "ddi")
    app = Keyword.get(opts, :app, "device-operation")

    args = ["-n", namespace, "get", "pods", "-l", "app=" <> app]

    {output, 0} =
      System.cmd("kubectl", args, stderr_to_stdout: true)

    # Skip the header.
    [_ | pods] =
      output
      |> String.split("\n")
      |> Enum.map(fn line -> line |> String.split() |> Enum.at(0) end)
      |> Enum.filter(&Function.identity/1)

    Enum.map(pods, fn pod ->
      Task.async(fn ->
        args = ["-n", namespace, "logs", pod]

        {output, 0} =
          System.cmd("kubectl", args, stderr_to_stdout: true)

        output |> String.split("\n") |> Enum.each(&IO.puts(&1))
      end)
    end)
    |> Task.await_many(20000)
  end
end

KubectlLogs.main()
