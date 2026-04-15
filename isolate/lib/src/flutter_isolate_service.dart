import 'dart:async';

import 'package:flutter/foundation.dart' as foundation;
import 'package:isolate_service/src/isolate_service.dart';

/// Flutter implementation of [IsolateService] using [foundation.compute].
final class FlutterIsolateService implements IsolateService {
  /// Creates a Flutter-based isolate service.
  const FlutterIsolateService();

  /// Runs [action] with [input] via [foundation.compute].
  @override
  Future<OutputT> executeInIsolate<InputT, OutputT>(
    FutureOr<OutputT> Function(InputT input) action,
    InputT input, {
    String? debugLabel,
  }) {
    return foundation.compute(
      action,
      input,
      debugLabel: debugLabel,
    );
  }
}
