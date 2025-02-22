defmodule Bender.Mixfile do
  use Mix.Project

  def project do
    [app: :bender,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :poison],
     mod: {Bender, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:poison, "~> 5.0"}
    ]
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "priv", "mix.exs", "README.md", "LICENSE.txt",],
     maintainers: ["Dylan Griffith"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/DylanGriffith/bender"}]
  end
end
