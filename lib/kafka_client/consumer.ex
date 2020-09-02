defmodule KafkaClient.Consumer do
  @moduledoc false

  @behaviour :erlkaf_consumer_callbacks

  require Logger

  @topics [{"topic_XYZ", callback_module: __MODULE__}]

  def new(consumer) do
    new(consumer, "#{consumer}_group")
  end

  def new(consumer, group) do
    options = %{
      client: [bootstrap_servers: "localhost:9092"],
      topic:  [auto_offset_reset: :smallest]
    }

    new(consumer, group, options)
  end

  def new(consumer, group, options) do
    :ok = :erlkaf.create_consumer_group(consumer, group, @topics, options[:client], options[:topic])
  end

  def init(topic, partition, offset, args) do
    Logger.info("#{inspect __MODULE__}.init(#{inspect {topic, partition, offset, args}})")

    {:ok, %{}}
  end

  def handle_message({:erlkaf_msg, _topic, _partition, _offset, _key, _value, _headers} = message, state) do
    Logger.info("#{inspect __MODULE__}.handle_message(#{inspect message})")

    {:ok, state}
  end

  def stop(producer), do: :erlkaf.stop_client(producer)
end
