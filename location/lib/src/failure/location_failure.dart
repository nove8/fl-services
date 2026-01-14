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

/// Failure that occurs when retrieving device information from the platform isn't possible.
final class UnsupportedPlatformFailure implements LocationFailure {
  /// Creates a [UnsupportedPlatformFailure].
  const UnsupportedPlatformFailure();
}
