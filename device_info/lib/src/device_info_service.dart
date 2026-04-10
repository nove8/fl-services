import 'dart:ui';

import 'package:async/async.dart';

/// A service interface for retrieving device-specific information.
abstract interface class DeviceInfoService {
  /// The current locale of the device (e.g. language and region settings).
  Result<Locale> get currentLocale;

  /// The physical screen size of the device in pixels.
  Result<Size> get screenSize;

  /// The name of the current operating system (e.g. "ios", "android").
  Result<String> get operatingSystem;

  /// An alphanumeric string that uniquely identifies a device to the app’s vendor.
  /// Available on iOS platform only. On other platforms will be [UnsupportedPlatformFailure].
  Future<Result<String?>> getIdentifierForVendor();

  /// The current operating system version.
  Future<Result<String>> getOsVersion();
}
