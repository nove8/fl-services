part of '../location_geolocator_service.dart';

final class _ServicePositionToCoordinatesMapper {
  const _ServicePositionToCoordinatesMapper();

  /// Converts [Position] to [Coordinates] by extracting latitude and longitude
  Coordinates transform(Position position) {
    return Coordinates(latitude: position.latitude, longitude: position.longitude);
  }
}

final class _AndroidForegroundNotificationConfigToServiceMapper {
  const _AndroidForegroundNotificationConfigToServiceMapper();

  ForegroundNotificationConfig? transform(
    AndroidForegroundNotificationConfig? androidForegroundNotificationConfig,
  ) {
    return androidForegroundNotificationConfig == null
        ? null
        : ForegroundNotificationConfig(
            notificationTitle: androidForegroundNotificationConfig.notificationTitle,
            notificationText: androidForegroundNotificationConfig.notificationBody,
            notificationChannelName: androidForegroundNotificationConfig.notificationChannelName,
            notificationIcon: AndroidResource(
              name: androidForegroundNotificationConfig.notificationIconResName,
            ),
            color: Color(androidForegroundNotificationConfig.colorCode),
          );
  }
}

final class _LocationPermissionToPermissionStatusMapper {
  const _LocationPermissionToPermissionStatusMapper();

  PermissionStatus transform(LocationPermission locationPermission) {
    return switch (locationPermission) {
      LocationPermission.denied || LocationPermission.unableToDetermine => PermissionStatus.denied,
      LocationPermission.deniedForever => PermissionStatus.permanentlyDenied,
      LocationPermission.whileInUse || LocationPermission.always => PermissionStatus.granted,
    };
  }
}
