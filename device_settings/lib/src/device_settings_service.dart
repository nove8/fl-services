import 'package:async/async.dart';
import 'package:device_settings_service/src/entity/device_settings_type.dart';

/// A service interface for opening platform device settings.
abstract interface class DeviceSettingsService {
  /// Opens the app settings for the given [type].
  ///
  /// Not all [type] values are supported on every platform.
  /// If the requested [type] is not supported, the general app settings
  /// screen will be opened as a fallback.
  Future<Result<void>> openAppSettings({required DeviceSettingsType type});
}
