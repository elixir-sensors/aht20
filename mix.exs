defmodule AHT20.MixProject do
  use Mix.Project

  @version "0.4.2"
  @source_url "https://github.com/mnishiguchi/aht20"

  def project do
    [
      app: :aht20,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: "Read temperature and humidity from AHT20 sensor in Elixir",
      deps: deps(),
      docs: docs(),
      package: package()
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
      {:circuits_i2c, "~> 2.0 or ~> 1.0 or ~> 0.3.0"},
      {:mox, "~> 1.0", only: :test},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp package do
    %{
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE*"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "AHT20 data sheet" =>
          "https://cdn-learn.adafruit.com/assets/assets/000/091/676/original/AHT20-datasheet-2020-4-16.pdf"
      }
    }
  end
end
