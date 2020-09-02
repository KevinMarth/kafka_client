defmodule KafkaClient.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Process.register(self(), __MODULE__)

    :ok = :erlkaf.start(:permanent)

    children = []
    options = [strategy: :one_for_one, name: KafkaClient.Supervisor]
    Supervisor.start_link(children, options)
  end
end
