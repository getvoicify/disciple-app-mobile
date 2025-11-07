import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 600});
<<<<<<< HEAD

  void run(VoidCallback action) {
    dispose();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer?.cancel();
=======
  bool get isActive => _timer?.isActive ?? false;

  void run(VoidCallback action) {
    cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    if (isActive) _timer?.cancel();
  }
>>>>>>> b05cc9c14293b73379b299e1f81efe7ebc10826b
}
