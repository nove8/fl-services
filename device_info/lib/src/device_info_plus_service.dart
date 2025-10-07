import 'dart:io';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:device_info_plus/device_info_plus.dart' as device_info_plus;
import 'package:device_info_service/src/device_info_service.dart';
import 'package:device_info_service/src/entity/app_platform.dart';
import 'package:device_info_service/src/failure/device_info_failure.dart';
import 'package:device_info_service/src/util/future_util.dart';
import 'package:flutter/foundation.dart';

/// Default implementation of [DeviceInfoService] using the device_info_plus package.
final class DeviceInfoPlusService implements DeviceInfoService {
  final device_info_plus.DeviceInfoPlugin _deviceInfoPlugin = device_info_plus.DeviceInfoPlugin();

  @override
  Future<Result<String?>> getIdentifierForVendor() {
    return _determineAppPlatform().flatMapAsync(_getIdentifierForVendorForAppPlatform);
  }

  Result<AppPlatform> _determineAppPlatform() {
    if (kIsWeb) {
      return AppPlatform.web.toSuccessResult();
    } else if (Platform.isIOS) {
      return AppPlatform.iOS.toSuccessResult();
    } else if (Platform.isAndroid) {
      return AppPlatform.android.toSuccessResult();
    } else {
      return const UnsupportedPlatformFailure().toFailureResult();
    }
  }

  Future<Result<String?>> _getIdentifierForVendorForAppPlatform(AppPlatform appPlatform) {
    return switch (appPlatform) {
      AppPlatform.iOS => _getIosIdentifierForVendor(),
      _ => const UnsupportedPlatformFailure().toFailureResultFuture(),
    };
  }

  Future<Result<String?>> _getIosIdentifierForVendor() {
    return _getIosDeviceInfo().mapAsync(
      (device_info_plus.IosDeviceInfo iosInfo) => iosInfo.identifierForVendor,
    );
  }

  Future<Result<device_info_plus.IosDeviceInfo>> _getIosDeviceInfo() {
    return _deviceInfoPlugin.iosInfo.mapToResult(GetIosDeviceInfoFailure.new);
  }
}
