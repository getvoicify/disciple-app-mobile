import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestQueueProvider = Provider((ref) => RequestQueue());

class RequestQueue {
  final List<RequestOptions> _pendingRequests = [];
  static final RequestQueue _instance = RequestQueue._internal();

  factory RequestQueue() => _instance;
  RequestQueue._internal();

  void add(RequestOptions request) {
    _pendingRequests.add(request);
  }

  List<RequestOptions> getAll() => List.from(_pendingRequests);

  void clear() => _pendingRequests.clear();
}
