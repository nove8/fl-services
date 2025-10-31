import 'package:common_result/common_result.dart';

/// Base class for device info failures.
sealed class DeviceInfoFailure implements Failure {}

/// Failure that occurs when retrieving device information from the platform.
final class GetDeviceInfoFailure implements DeviceInfoFailure {
  /// Creates a [GetDeviceInfoFailure] with the underlying error.
  const GetDeviceInfoFailure(this.error);

  /// The underlying error object from the platform API call.
  final Object error;

  @override
  String toString() {
    return 'GetDeviceInfoFailure{error: $error}';
  }
}

/// Failure that occurs when retrieving device information from the platform isn't possible.
final class UnsupportedPlatformFailure implements DeviceInfoFailure {
  /// Creates a [UnsupportedPlatformFailure].
  const UnsupportedPlatformFailure();
}
