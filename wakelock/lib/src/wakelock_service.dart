import 'package:async/async.dart';

/// A service interface for managing the device wakelock.
///
/// Wakelock prevents the device screen from turning off automatically.
abstract interface class WakelockService {
  /// Sets the wakelock enabled state based on the [isEnabled] flag.
  Future<Result<void>> setWakelockEnabled({required bool isEnabled});

  /// Returns whether the wakelock is currently enabled.
  Future<Result<bool>> isEnabled();
}
