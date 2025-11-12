class SocketConfig {
  final List<String> transports;
  final int reconnectionAttempts;
  final int reconnectionDelay;
  final int reconnectionDelayMax;
  final double randomizationFactor;
  final int timeout;
  final int ackTimeout;
  final int retries;
  final Map<String, dynamic> extraHeaders;

  const SocketConfig({
    this.transports = const ['websocket'],
    this.reconnectionAttempts = 5,
    this.reconnectionDelay = 1000,
    this.reconnectionDelayMax = 5000,
    this.randomizationFactor = 0.5,
    this.timeout = 20000,
    this.ackTimeout = 1000,
    this.retries = 5,
    this.extraHeaders = const {},
  });
}
