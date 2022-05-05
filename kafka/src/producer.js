const { Kafka } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'my-app',
  brokers: ['localhost:9092'],
  requestTimeout: 6000,
});

const producer = kafka.producer();

const run = async () => {
  // Producing
  await producer.connect();
  const getRandomNumber = () => Math.round(Math.random(10) * 1000);
  const createMessage = (num) => ({
    key: `key-${num}`,
    value: `value-${num}`,
  });

  while (true) {
    await new Promise((res) => setTimeout(res, 3000));
    await producer.send({
      topic: 'test-topic',
      messages: [createMessage(getRandomNumber())],
    });
  }
};

run().catch(console.error);
