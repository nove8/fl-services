import 'package:async/async.dart';

/// A service interface for retrieving device-specific information.
abstract interface class DeviceInfoService {
  /// An alphanumeric string that uniquely identifies a device to the app’s vendor.
  /// Available on iOS platform only. On other platforms will be [UnsupportedPlatformFailure].
  Future<Result<String?>> getIdentifierForVendor();

  /// The current operating system version.
  Future<Result<String>> getOsVersion();
}
