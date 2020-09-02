defmodule KafkaClient do
  @moduledoc false

  alias KafkaClient.{Consumer, Producer, Topic}

  @topic "topic_XYZ"

  def demo(messages \\ ~w(foo bar baz)) do
    consumer = :consumer_XYZ
    producer = :producer_XYZ

    _ = Topic.new(producer, @topic)
    :ok = Consumer.new(consumer)
    :ok = Producer.new(producer)
    Enum.each(messages, fn message -> produce(producer, message) end)
    Process.sleep(1000*5)
    :ok = Producer.stop(producer)
    :ok = Consumer.stop(consumer)
  end

  defp produce(producer, message) do
    key = message <> "_key"
    value = message <> "_value"
    :ok = Producer.produce(producer, @topic, key, value)
  end
end
