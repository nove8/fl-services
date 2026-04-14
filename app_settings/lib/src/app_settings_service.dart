import 'package:app_settings_service/src/entity/app_settings_type.dart';
import 'package:async/async.dart';

/// A service interface for opening platform app settings.
abstract interface class AppSettingsService {
  /// Opens the app settings for the given [type].
  ///
  /// Not all [type] values are supported on every platform.
  /// If the requested [type] is not supported, the general app settings
  /// screen will be opened as a fallback.
  Future<Result<void>> openAppSettings({required AppSettingsType type});
}
