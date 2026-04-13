import 'package:app_settings/app_settings.dart' as lib;
import 'package:app_settings_service/src/app_settings_service.dart';
import 'package:app_settings_service/src/entity/app_settings_type.dart';
import 'package:app_settings_service/src/failure/app_settings_failure.dart';
import 'package:app_settings_service/src/util/future_util.dart';
import 'package:async/async.dart';

part 'mapper/app_settings_type_mapper.dart';

/// Default implementation of [AppSettingsService] using app_settings package.
final class AppSettingsServiceImpl implements AppSettingsService {
  /// Creates an [AppSettingsServiceImpl].
  const AppSettingsServiceImpl();

  static const _AppSettingsTypeServiceToLibMapper _typeMapper = _AppSettingsTypeServiceToLibMapper();

  @override
  Future<Result<void>> openAppSettings({required AppSettingsType type}) {
    return lib.AppSettings.openAppSettings(
      type: _typeMapper.transform(type),
    ).mapToResult(AppSettingsOpenFailure.new);
  }
}
