import 'package:common_result/common_result.dart';

/// Base class for location failures
sealed class LocationFailure implements Failure {}

/// Failure class for errors occurring during check permission
final class CheckPermissionFailure implements LocationFailure {
  /// Creates a [CheckPermissionFailure].
  const CheckPermissionFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'CheckPermissionFailure{error: $error}';
  }
}

/// Failure class for errors occurring during permission requests
final class RequestPermissionFailure implements LocationFailure {
  /// Creates a [RequestPermissionFailure].
  const RequestPermissionFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'RequestPermissionFailure{error: $error}';
  }
}

/// Failure class for errors occurring during location service status check
final class LocationServiceEnabledFailure implements LocationFailure {
  /// Creates a [LocationServiceEnabledFailure].
  const LocationServiceEnabledFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'LocationServiceEnabledFailure{error: $error}';
  }
}

/// Failure class for errors occurring during retrieval of last known coordinates
final class GetLastKnownCoordinatesFailure implements LocationFailure {
  /// Creates a [GetLastKnownCoordinatesFailure].
  const GetLastKnownCoordinatesFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'GetLastKnownCoordinatesFailure{error: $error}';
  }
}

/// Failure class for errors occurring during opening the app settings
final class OpenAppSettingFailure implements LocationFailure {
  /// Creates a [OpenAppSettingFailure].
  const OpenAppSettingFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'OpenAppSettingFailure{error: $error}';
  }
}

/// Failure class for errors occurring during opening the location settings
final class OpenLocationSettingFailure implements LocationFailure {
  /// Creates a [OpenLocationSettingFailure].
  const OpenLocationSettingFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'OpenLocationSettingFailure{error: $error}';
  }
}
