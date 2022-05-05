const { Kafka, logLevel } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'my-app',
  brokers: ['localhost:9092'],
  requestTimeout: 6000,
  logCreator: (_) => (value) => {
    console.log(`${value.label} ${value.log.timestamp} ${value.log.message}`);
  },
});

const consumer = kafka.consumer({ groupId: 'test-group' });

const run = async () => {
  await consumer.connect();
  await consumer.subscribe({ topic: 'test-topic' });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const prefix = `${topic}[${partition} | ${message.offset}] / ${message.timestamp}`;
      const now = new Date().toISOString();
      console.log(`- ${prefix} ${message.key}#${message.value} ${now}`);
    },
  });
};

run().catch(console.error);
