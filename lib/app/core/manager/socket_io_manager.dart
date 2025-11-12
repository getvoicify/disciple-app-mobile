import 'dart:async';

import 'package:disciple/app/config/app_config.dart';
import 'package:disciple/app/config/app_logger.dart';
import 'package:disciple/app/core/manager/model/socket_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Provider for a singleton SocketIoManager instance
final socketProvider = Provider<SocketIoManager>((ref) {
  final socket = SocketIoManager(
    AppConfig.socketIoUrl,
    config: const SocketConfig(reconnectionAttempts: 10, timeout: 30000),
  );

  unawaited(socket.connect());
  ref.onDispose(() => socket.disconnect());
  return socket;
});

class SocketIoManager {
  final _logger = getLogger('SocketIoManager');
  late io.Socket _socket;
  final String baseUrl;
  final SocketConfig config;
  Timer? _pingTimer;
  final Map<String, StreamController<dynamic>> _eventControllers = {};
  bool _isConnecting = false;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SocketIoManager(this.baseUrl, {SocketConfig? config})
    : config = config ?? const SocketConfig();

  /// Initialize and connect to the Socket.IO server
  Future<void> connect() async {
    if (_isConnecting || _isConnected) {
      _logger.w('⚠️ Connection already in progress or established');
      return;
    }

    _isConnecting = true;

    try {
      final headers = {...config.extraHeaders};

      _socket = io.io(
        baseUrl,
        io.OptionBuilder()
            .setTransports(config.transports)
            .enableReconnection()
            .setReconnectionAttempts(config.reconnectionAttempts)
            .setReconnectionDelay(config.reconnectionDelay)
            .setReconnectionDelayMax(config.reconnectionDelayMax)
            .setRandomizationFactor(config.randomizationFactor)
            .setTimeout(config.timeout)
            .setAckTimeout(config.ackTimeout)
            .setRetries(config.retries)
            .setExtraHeaders(headers)
            .enableForceNew()
            .build(),
      );

      _setupEventHandlers();
    } catch (e) {
      _isConnecting = false;
      _logger.e('Failed to initialize socket: $e');
      _emitToStream('error', e.toString());
    }
  }

  /// Set up socket event handlers
  void _setupEventHandlers() {
    _socket
      ..onConnect((_) {
        _isConnected = true;
        _isConnecting = false;
        _logger.i('Socket connected: ${_socket.id}');
        _startPingPong(); // Start ping-pong
        _emitToStream('connect', 'connected');
      })
      ..onDisconnect((_) {
        _isConnected = false;
        _isConnecting = false;
        _pingTimer?.cancel();
        _logger.i('Socket disconnected');
        _emitToStream('disconnect', 'disconnected');
      })
      ..onReconnect((attempt) {
        _logger.i('Reconnected after $attempt attempts');
        _emitToStream('reconnect', attempt);
      })
      ..onReconnectFailed((_) {
        _isConnecting = false;
        _logger.i('Reconnection failed after max attempts');
        _emitToStream('reconnect_failed', null);
      })
      ..onError((err) {
        _isConnecting = false;
        _logger.e('Socket error: $err');
        _emitToStream('error', err);
      });
  }

  void _startPingPong() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) {
        _socket.emit('ping', DateTime.now().millisecondsSinceEpoch);
      }
    });
  }

  /// Emit an event to the server
  void emit(String event, dynamic data) {
    if (!_isConnected) {
      _logger.w('⚠️ Emit failed — socket not connected');
      return;
    }
    _socket.emit(event, data);
  }

  /// Listen to an event as a broadcast stream
  Stream<dynamic> on(String event) {
    // Return existing controller if present
    if (_eventControllers[event] != null) {
      return _eventControllers[event]!.stream;
    }

    // Create a broadcast controller
    final controller = StreamController<dynamic>.broadcast(
      onCancel: () async {
        // Automatically clean up when all listeners unsubscribe
        _socket.off(event);
        await _eventControllers[event]?.close();
        _eventControllers.remove(event);
      },
    );

    _eventControllers[event] = controller;

    _socket.on(event, (data) {
      if (!controller.isClosed) {
        controller.add(data);
      }
    });

    return controller.stream;
  }

  /// Stop listening to an event
  Future<void> off(String event) async {
    if (_eventControllers.containsKey(event)) {
      await _eventControllers[event]?.close();
      _eventControllers.remove(event);
    }
    _socket.off(event);
  }

  /// Disconnect the socket and clean up
  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;
    _logger.i('Disconnecting socket...');
    _isConnected = false;
    _socket.dispose();

    for (final controller in _eventControllers.values) {
      await controller.close();
    }
    _eventControllers.clear();
  }

  /// Emit internal stream events
  void _emitToStream(String event, dynamic data) {
    if (_eventControllers[event] != null &&
        !_eventControllers[event]!.isClosed) {
      _eventControllers[event]!.add(data);
    }
  }
}
