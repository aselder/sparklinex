defmodule Sparklinex.MixProject do
  use Mix.Project

  def project do
    [
      app: :sparklinex,
      version: "0.3.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
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
      {:mogrify, "~> 0.7.0"},
      {:statistics, "~> 0.5.0"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Andrew Selder"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/aselder/sparklinex"
      }
    ]
  end

  defp description do
    """
    Library for generating PNG sparkline graphs.
    """
  end
end
