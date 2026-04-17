import 'package:app_settings/app_settings.dart' as lib;
import 'package:async/async.dart';
import 'package:device_settings_service/src/device_settings_service.dart';
import 'package:device_settings_service/src/entity/device_settings_type.dart';
import 'package:device_settings_service/src/failure/device_settings_failure.dart';
import 'package:device_settings_service/src/util/future_util.dart';

part 'mapper/device_settings_type_service_to_app_settings_type_lib_mapper.dart';

/// Default implementation of [DeviceSettingsService] using app_settings package.
final class DeviceSettingsServiceImpl implements DeviceSettingsService {
  /// Creates a [DeviceSettingsServiceImpl].
  const DeviceSettingsServiceImpl();

  static const _DeviceSettingsTypeServiceToAppSettingsTypeLibMapper _settingsTypeMapper =
      _DeviceSettingsTypeServiceToAppSettingsTypeLibMapper();

  @override
  Future<Result<void>> openSettings({required DeviceSettingsType type}) {
    return lib.AppSettings.openAppSettings(
      type: _settingsTypeMapper.transform(type),
    ).mapToResult(DeviceSettingsOpenFailure.new);
  }
}
