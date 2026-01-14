import 'dart:ui';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_service/src/entity/android_foreground_notification_config.dart';
import 'package:location_service/src/entity/app_platform.dart';
import 'package:location_service/src/entity/coordinates.dart';
import 'package:location_service/src/entity/permission_status.dart';
import 'package:location_service/src/failure/location_failure.dart';
import 'package:location_service/src/location_service.dart';
import 'package:location_service/src/util/future_util.dart';
import 'package:location_service/src/util/position_util.dart';

/// Default implementation of [LocationService] using the geolocator package.
final class LocationGeolocatorService implements LocationService {
  /// Creates a [LocationGeolocatorService]
  const LocationGeolocatorService();

  static const LocationAccuracy _locationAccuracy = LocationAccuracy.bestForNavigation;
  static const Duration _intervalDuration = Duration(seconds: 1);

  @override
  Future<Result<bool>> get isLocationServiceEnabled {
    return Geolocator.isLocationServiceEnabled().mapToResult(LocationServiceEnabledFailure.new);
  }

  @override
  Stream<Coordinates?> getCoordinatesStream(
    AppPlatform appPlatform, [
    AndroidForegroundNotificationConfig? config,
  ]) {
    final LocationSettings locationSettings = _obtainLocationSettings(appPlatform, config);
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).map((Position position) => position.toCoordinates()).handleError((_) => null);
  }

  @override
  Result<double> distanceBetween(
    Coordinates beginCoordinates,
    Coordinates? endCoordinates,
  ) {
    final double latitude = beginCoordinates.latitude;
    final double longitude = beginCoordinates.longitude;
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      endCoordinates?.latitude ?? latitude,
      endCoordinates?.longitude ?? longitude,
    ).toSuccessResult();
  }

  @override
  Future<Result<PermissionStatus>> checkPermission() {
    return Geolocator.checkPermission()
        .mapToResult(CheckPermissionFailure.new)
        .flatMapAsync(_mapGeolocatorLocationPermissionToPermission);
  }

  @override
  Future<Result<PermissionStatus>> requestPermission() {
    return Geolocator.requestPermission()
        .mapToResult(RequestPermissionFailure.new)
        .flatMapAsync(_mapGeolocatorLocationPermissionToPermission);
  }

  @override
  Future<Result<Coordinates?>> getLastKnownCoordinates() {
    return Geolocator.getLastKnownPosition()
        .mapToResult(GetLastKnownCoordinatesFailure.new)
        .mapAsync((Position? position) => position?.toCoordinates());
  }

  @override
  Future<Result<bool>> openAppSettings() {
    return Geolocator.openAppSettings().mapToResult(OpenAppSettingFailure.new);
  }

  @override
  Future<Result<bool>> openLocationSettings() {
    return Geolocator.openLocationSettings().mapToResult(OpenLocationSettingFailure.new);
  }

  LocationSettings _obtainLocationSettings(
    AppPlatform appPlatform,
    AndroidForegroundNotificationConfig? config,
  ) {
    return switch (appPlatform) {
      AppPlatform.iOS => AppleSettings(
        activityType: ActivityType.fitness,
        accuracy: _locationAccuracy,
      ),
      AppPlatform.android => AndroidSettings(
        intervalDuration: _intervalDuration,
        accuracy: _locationAccuracy,
        foregroundNotificationConfig: _obtainAndroidForegroundNotificationConfig(config),
      ),
      AppPlatform.web => WebSettings(),
    };
  }

  ForegroundNotificationConfig? _obtainAndroidForegroundNotificationConfig(
    AndroidForegroundNotificationConfig? config,
  ) {
    return config == null
        ? null
        : ForegroundNotificationConfig(
            notificationTitle: config.notificationTitle,
            notificationText: config.notificationText,
            notificationChannelName: config.notificationChannelName,
            notificationIcon: AndroidResource(name: config.notificationIcon),
            color: Color(config.colorCode),
          );
  }

  Result<PermissionStatus> _mapGeolocatorLocationPermissionToPermission(
    LocationPermission locationPermission,
  ) {
    return switch (locationPermission) {
      LocationPermission.denied || LocationPermission.unableToDetermine => PermissionStatus.denied,
      LocationPermission.deniedForever => PermissionStatus.permanentlyDenied,
      LocationPermission.whileInUse || LocationPermission.always => PermissionStatus.granted,
    }.toSuccessResult();
  }
}
