defmodule AHT20.MixProject do
  use Mix.Project

  def project do
    [
      app: :aht20,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_i2c, "~> 0.1"},
      # {:mox, "~> 1.0.0", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
      # {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      # {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      # {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
