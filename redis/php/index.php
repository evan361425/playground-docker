<?php

declare(ticks=1);

echo "Redis version: " . phpversion("redis") . PHP_EOL;
$redis = new \Redis();
$redis->connect('redis', 6379, 30, null, 0, 30);
$redis->select(3);

echo "Timeout: " . strval($redis->getTimeout()) . PHP_EOL;
echo "Read Timeout: " . strval($redis->getReadTimeout())  . PHP_EOL;

$handler = function ($signal) use ($redis) {
  switch ($signal) {
    case SIGINT:
      echo "Ping" . PHP_EOL;
      $redis->ping();
      break;
    default:
      echo "Get Signal: " . strval($signal) . PHP_EOL;
      $redis->close();
      exit;
  }
};
pcntl_signal(SIGINT, $handler);
pcntl_signal(SIGHUP, $handler);
pcntl_signal(SIGTERM, $handler);
pcntl_signal(SIGTSTP, $handler);

fwrite(STDOUT, "Start\n");
while (true) {
  sleep(1);
}
