import 'package:app_settings_service/src/entity/app_settings_type.dart';
import 'package:async/async.dart';

/// A service interface for opening platform app settings.
abstract interface class AppSettingsService {
  /// Opens the app settings for the given [type].
  Future<Result<void>> openAppSettings({required AppSettingsType type});
}
