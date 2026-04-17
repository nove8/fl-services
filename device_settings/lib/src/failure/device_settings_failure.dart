import 'package:common_result/common_result.dart';

/// Base class for device settings failures.
sealed class DeviceSettingsFailure implements Failure {}

/// Failure that occurs when opening device settings.
final class DeviceSettingsOpenFailure implements DeviceSettingsFailure {
  /// Creates a [DeviceSettingsOpenFailure].
  const DeviceSettingsOpenFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'DeviceSettingsOpenFailure{error: $error}';
  }
}
