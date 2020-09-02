# Kafka Client

## The `erlkaf` Kafka Client

The [erlkaf](https://github.com/silviucpp/erlkaf) Kafka client is an Erlang package based on [librdkafka](https://github.com/edenhill/librdkafka). The `librdkafka` library is a C implementation of the Kafka protocol for producing and consuming messages. The `erlkaf` package adds a layer of C++ NIFs over `lidrdkafka`. The NIFs are designed to be asynchronous and well-behaved in Erlang schedulers.

### Usage

`erlkaf` provides configurable producer and consumer behaviours, and multiple producers and consumers can be created. The producer behaviour can be configured to receive delivery notifications for all messages or only on errors. The consumer behaviour is based on consumer groups, and messages can be received individually or in batches.

The `erlkaf` supervision tree contains a manager process, the producer processes, and the consumer group processes. A consumer group process supervises the consumer processes within the group. There is no `start_link` function provided, so it is not possible to atomically link the `erlkaf` supervision tree to the overall application supervision tree. The `erlkaf` supervision tree appears to withstand Kafka outages without the [cascading crashes](https://rentpath.slack.com/archives/C0GEF6TEJ/p1597955360001900) experienced with `brod`. However, more experience in production scenarios is needed to fully assess supervision behavior.

### Concerns and Considerations

The `librdkafka` library is [supported by Confluent](https://github.com/edenhill/librdkafka#commercial-support) and has numerous [language bindings](https://github.com/edenhill/librdkafka#language-bindings). Such support and widespread usage hopefully implies correctness and stability. Nevertheless, `librdkafka` is a significant body of C code. Similarly, `erlkaf` is a significant body of C++ code. The concerns about memory and thread safety generally applicable to any C/C++ implementation apply here.

The `librdkafka` library is a low-level API. No support for higher-level APIs such as Kafka Streams is available or envisioned.

The messages produced by `erlkaf` producers are [queued](https://github.com/silviucpp/erlkaf#message-queues) until delivered and acknowledged. If a `local_disk_queue` is chosen as a fallback option, the local storage must be provided by the deployment container.

A build of `erlkaf` also includes a build of `librdkafka` and the supporting memory queue implementation. A C/C++ compiler and the `make` command will be required in the build container. A compiler error for `erlkaf` was noted with GCC-10. This issue can be resolved with a simple PR.

The [BroadwayKafka](https://hexdocs.pm/broadway_kafka/BroadwayKafka.Producer.html) package uses the `brod` client. A Broadway Kafka consumer based on `erlkaf` does not (yet?) seem to exist.

The `lager` logging package is a dependency of `erlkaf`, and `lager` will have to be configured to coexist with Elixir logging.

### Demo on Local Computer (MacOS)

**WARNING**: This will install `openssl`, `lz4`, and `zstd` via `brew` on your local computer.

1. Complete steps 1 and 2 of the [Apache Kafka Quickstart](https://kafka.apache.org/quickstart).
1. Run `mix do deps.get, compile`.
1. Run `iex -S mix`.
1. Call `KafkaClient.demo()` at the `iex` prompt.
