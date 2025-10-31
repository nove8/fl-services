import 'package:async/async.dart';
import 'package:permission_service/src/entity/permission.dart';
import 'package:permission_service/src/entity/permission_status.dart';

/// A service interface for handling device permissions.
abstract interface class PermissionService {
  /// Requests the specified [permission].
  ///
  /// Returns a [Result] containing the [PermissionStatus]. If the permission is not required,
  /// a successful result of [PermissionStatus.granted] will be returned.
  /// In case of error, a [RequestPermissionFailure] will be returned as failure.
  Future<Result<PermissionStatus>> requestPermission(Permission permission);

  /// Gets the status of the specified [permission].
  ///
  /// Returns a [Result] containing the [PermissionStatus]. If the permission is not required,
  /// a successful result of [PermissionStatus.granted] will be returned.
  /// In case of error, a [GetPermissionStatusFailure] will be returned as failure.
  Future<Result<PermissionStatus>> getPermissionStatus(Permission permission);
}
