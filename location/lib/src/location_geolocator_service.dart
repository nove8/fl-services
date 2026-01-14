import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_service/src/entity/android_foreground_notification_config.dart';
import 'package:location_service/src/entity/app_platform.dart';
import 'package:location_service/src/entity/coordinates.dart';
import 'package:location_service/src/entity/permission_status.dart';
import 'package:location_service/src/failure/location_failure.dart';
import 'package:location_service/src/location_service.dart';
import 'package:location_service/src/util/future_util.dart';

part 'mapper/location_geolocator_mapper.dart';

/// Default implementation of [LocationService] using the geolocator package.
final class LocationGeolocatorService implements LocationService {
  /// Creates a [LocationGeolocatorService]
  const LocationGeolocatorService();

  static const _ServicePositionToCoordinatesMapper _servicePositionToCoordinatesMapper =
      _ServicePositionToCoordinatesMapper();
  static const _AndroidForegroundNotificationConfigToServiceMapper
  _androidForegroundNotificationConfigToServiceMapper = _AndroidForegroundNotificationConfigToServiceMapper();
  static const _LocationPermissionToPermissionStatusMapper _locationPermissionToPermissionStatusMapper =
      _LocationPermissionToPermissionStatusMapper();

  static const LocationAccuracy _locationAccuracy = LocationAccuracy.bestForNavigation;
  static const Duration _intervalDuration = Duration(seconds: 1);

  @override
  Future<Result<bool>> get isLocationServiceEnabled {
    return Geolocator.isLocationServiceEnabled().mapToResult(LocationServiceEnabledFailure.new);
  }

  @override
  Result<Stream<Coordinates?>> getCoordinatesStream([
    AndroidForegroundNotificationConfig? androidForegroundNotificationConfig,
  ]) {
    return _obtainLocationSettings(androidForegroundNotificationConfig).map((
      LocationSettings locationSettings,
    ) {
      return Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).map(_servicePositionToCoordinatesMapper.transform).handleError((_) => null);
    });
  }

  @override
  Result<double> distanceBetween({
    required Coordinates beginCoordinates,
    required Coordinates endCoordinates,
  }) {
    return Geolocator.distanceBetween(
      beginCoordinates.latitude,
      beginCoordinates.longitude,
      endCoordinates.latitude,
      endCoordinates.longitude,
    ).toSuccessResult();
  }

  @override
  Future<Result<PermissionStatus>> checkPermission() {
    return Geolocator.checkPermission()
        .mapToResult(CheckPermissionFailure.new)
        .mapAsync(_locationPermissionToPermissionStatusMapper.transform);
  }

  @override
  Future<Result<PermissionStatus>> requestPermission() {
    return Geolocator.requestPermission()
        .mapToResult(RequestPermissionFailure.new)
        .mapAsync(_locationPermissionToPermissionStatusMapper.transform);
  }

  @override
  Future<Result<Coordinates?>> getLastKnownCoordinates() {
    return _getLastKnownPosition()
        .mapToResult(GetLastKnownCoordinatesFailure.new)
        .mapNotNullValueAsync(_servicePositionToCoordinatesMapper.transform);
  }

  Result<LocationSettings> _obtainLocationSettings(
    AndroidForegroundNotificationConfig? androidForegroundNotificationConfig,
  ) {
    return _determineAppPlatform().map((AppPlatform appPlatform) {
      return switch (appPlatform) {
        AppPlatform.iOS => AppleSettings(
          activityType: ActivityType.fitness,
          accuracy: _locationAccuracy,
        ),
        AppPlatform.android => AndroidSettings(
          intervalDuration: _intervalDuration,
          accuracy: _locationAccuracy,
          foregroundNotificationConfig: _androidForegroundNotificationConfigToServiceMapper.transform(
            androidForegroundNotificationConfig,
          ),
        ),
        AppPlatform.web => WebSettings(),
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

  Future<Position?> _getLastKnownPosition() async {
    // Await here to fix unhandled UnsupportedError on web
    // ignore: unnecessary_await_in_return
    return await Geolocator.getLastKnownPosition();
  }
}
