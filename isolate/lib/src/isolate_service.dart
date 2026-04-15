import 'dart:async';

/// A service interface for executing functions in a background isolate.
abstract interface class IsolateService {
  /// Executes [action] with [input] in a background isolate.
  ///
  /// The [action] must be a top-level or static function because isolate
  /// execution cannot use closures or instance methods that capture context.
  ///
  /// The optional [debugLabel] is used to identify the isolate in debugging
  /// tools.
  Future<OutputT> executeInIsolate<InputT, OutputT>(
    FutureOr<OutputT> Function(InputT input) action,
    InputT input, {
    String? debugLabel,
  });
}
