import 'package:common_result/common_result.dart';

/// Base class for wakelock failures.
sealed class WakelockFailure implements Failure {}

/// Failure that occurs when setting the wakelock enabled state.
final class SetWakelockEnabledFailure implements WakelockFailure {
  /// Creates a [SetWakelockEnabledFailure].
  const SetWakelockEnabledFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'SetWakelockEnabledFailure{error: $error}';
  }
}

/// Failure that occurs when checking the wakelock status.
final class WakelockStatusCheckFailure implements WakelockFailure {
  /// Creates a [WakelockStatusCheckFailure].
  const WakelockStatusCheckFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'WakelockStatusCheckFailure{error: $error}';
  }
}
