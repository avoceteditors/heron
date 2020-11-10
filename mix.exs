defmodule Heron.MixProject do
  use Mix.Project

  def project do
    [
      app: :heron,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        heron: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          steps: [:assemble]
        ]
      ],
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Heron.CLI, emu_args: ["-name heron@localhost"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto, :myxql],
      mod: {Heron.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~>3.5.3"},
      {:ex_doc, "~>0.22", only: :dev, runtime: false},
      {:git_ops, "~>2.0.1"},
      {:myxql, "~> 0.4.0"},

    ]
  end
end
