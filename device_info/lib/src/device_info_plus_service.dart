import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:device_info_plus/device_info_plus.dart' as device_info_plus;
import 'package:device_info_service/src/device_info_service.dart';
import 'package:device_info_service/src/failure/device_info_failure.dart';
import 'package:device_info_service/src/util/future_util.dart';

/// Default implementation of [DeviceInfoService] using the device_info_plus package.
final class DeviceInfoPlusService implements DeviceInfoService {
  final device_info_plus.DeviceInfoPlugin _deviceInfoPlugin = device_info_plus.DeviceInfoPlugin();

  @override
  Future<Result<String?>> getIosIdentifierForVendor() {
    return _getIosDeviceInfo().mapAsync(
      (device_info_plus.IosDeviceInfo iosInfo) => iosInfo.identifierForVendor,
    );
  }

  /// Retrieves iOS device information from the platform.
  Future<Result<device_info_plus.IosDeviceInfo>> _getIosDeviceInfo() {
    return _deviceInfoPlugin.iosInfo.mapToResult(GetIosDeviceInfoFailure.new);
  }
}
