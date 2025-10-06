import 'package:common_result/common_result.dart';

/// Base class for device info failures
sealed class DeviceInfoFailure implements Failure {}

/// Failure that occurs when retrieving iOS device information from the platform
final class GetIosDeviceInfoFailure implements DeviceInfoFailure {
  /// Creates a [GetIosDeviceInfoFailure] with the underlying error
  const GetIosDeviceInfoFailure(this.error);

  /// The underlying error object from the platform API call
  final Object error;

  @override
  String toString() {
    return 'GetDeviceInfoFailure{error: $error}';
  }
}
