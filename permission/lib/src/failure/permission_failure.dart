import 'package:common_result/common_result.dart';

/// Base class for permission failures
sealed class PermissionFailure implements Failure {}

/// Failure that occurs when retrieving device information from the platform isn't possible.
final class UnsupportedPlatformFailure implements PermissionFailure {
  /// Creates a [UnsupportedPlatformFailure].
  const UnsupportedPlatformFailure();
}

/// Failure class for errors occurring during permission requests
final class RequestPermissionFailure implements PermissionFailure {
  /// Creates a [RequestPermissionFailure].
  const RequestPermissionFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'RequestPermissionFailure{error: $error}';
  }
}

/// Failure class for errors occurring during permission status retrieval
final class GetPermissionStatusFailure implements PermissionFailure {
  /// Creates a [GetPermissionStatusFailure].
  const GetPermissionStatusFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'GetPermissionStatusFailure{error: $error}';
  }
}

/// Failure class for errors occurring during permission rationale check
class CheckShouldShowRequestRationaleFailure implements PermissionFailure {
  /// Creates a [CheckShouldShowRequestRationaleFailure].
  const CheckShouldShowRequestRationaleFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'CheckShouldShowRequestRationaleFailure{error: $error}';
  }
}
