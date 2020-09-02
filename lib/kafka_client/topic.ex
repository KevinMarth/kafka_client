defmodule KafkaClient.Topic do
  @moduledoc false

  def new(client, topic), do: new(client, topic, request_required_acks: 1)
  def new(client, topic, options), do: :erlkaf.create_topic(client, topic, options)
end
