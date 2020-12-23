defmodule Heron.MixProject do
  use Mix.Project

  def project do
    [
      app: :heron,
      version: "0.1.0",
      elixir: "~> 1.0",
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      #aliases: aliases(),
      deps: deps(),
      escript: [main_module: Heron.CLI, emu_args: ["-name heron@localhost"]]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Heron.Application, []}
    ]
  end

  defp deps do
    [
    ]
  end
  defp aliases do
    [
    ]
  end
end
