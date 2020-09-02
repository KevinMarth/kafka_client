defmodule KafkaClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :kafka_client,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:lager, :logger],
      mod: {KafkaClient.Application, []}
    ]
  end

  defp deps do
    [
      {:erlkaf, github: "silviucpp/erlkaf", branch: "master"}
    ]
  end
end
