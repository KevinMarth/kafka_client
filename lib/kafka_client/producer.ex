defmodule KafkaClient.Producer do
  @moduledoc false

  @behaviour :erlkaf_producer_callbacks

  require Logger

  def new(producer) do
    options = [
      bootstrap_servers: "localhost:9092",
      delivery_report_only_error: false,
      delivery_report_callback: __MODULE__
    ]

    new(producer, options)
  end

  def new(producer, options) do
    :ok = :erlkaf.create_producer(producer, options)
  end

  def produce(producer, topic, key, value) do
    :ok = :erlkaf.produce(producer, topic, key, value)
  end

  def delivery_report(status, message) do
    Logger.info("#{inspect __MODULE__}.delivery_report(#{inspect {status, message}})")
    :ok
  end

  def stop(producer), do: :erlkaf.stop_client(producer)
end
