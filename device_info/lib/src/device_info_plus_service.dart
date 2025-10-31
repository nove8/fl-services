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
    return _getDeviceInfoOnMobilePlatforms(
      (device_info_plus.IosDeviceInfo iosInfo) => iosInfo.identifierForVendor.toSuccessResult(),
      (_) => const UnsupportedPlatformFailure().toFailureResult(),
    );
  }

  @override
  Future<Result<String>> getOsVersion() {
    return _getDeviceInfoOnMobilePlatforms(
      (device_info_plus.IosDeviceInfo iosInfo) => iosInfo.systemVersion.toSuccessResult(),
      (device_info_plus.AndroidDeviceInfo androidInfo) => androidInfo.version.release.toSuccessResult(),
    );
  }

  Future<Result<T>> _getDeviceInfoOnMobilePlatforms<T>(
    Result<T> Function(device_info_plus.IosDeviceInfo iosInfo) iosInfoProvider,
    Result<T> Function(device_info_plus.AndroidDeviceInfo androidInfo) androidInfoProvider,
  ) {
    return _getDeviceInfo(
      iosInfoProvider,
      androidInfoProvider,
      (_) => const UnsupportedPlatformFailure().toFailureResult(),
    );
  }

  Future<Result<T>> _getDeviceInfo<T>(
    Result<T> Function(device_info_plus.IosDeviceInfo iosInfo) iosInfoProvider,
    Result<T> Function(device_info_plus.AndroidDeviceInfo androidInfo) androidInfoProvider,
    Result<T> Function(device_info_plus.WebBrowserInfo webInfo) webInfoProvider,
  ) {
    return _determineAppPlatform().flatMapAsync((AppPlatform appPlatform) {
      return switch (appPlatform) {
        AppPlatform.iOS => _getPlatformDeviceInfoResult(
          (device_info_plus.DeviceInfoPlugin infoPlugin) => infoPlugin.iosInfo,
        ).flatMapAsync(iosInfoProvider),
        AppPlatform.android => _getPlatformDeviceInfoResult(
          (device_info_plus.DeviceInfoPlugin infoPlugin) => infoPlugin.androidInfo,
        ).flatMapAsync(androidInfoProvider),
        AppPlatform.web => _getPlatformDeviceInfoResult(
          (device_info_plus.DeviceInfoPlugin infoPlugin) => infoPlugin.webBrowserInfo,
        ).flatMapAsync(webInfoProvider),
      };
    });
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

  Future<Result<T>> _getPlatformDeviceInfoResult<T>(
    Future<T> Function(device_info_plus.DeviceInfoPlugin infoPlugin) deviceInfoProvider,
  ) {
    return deviceInfoProvider.call(_deviceInfoPlugin).mapToResult(GetDeviceInfoFailure.new);
  }
}
