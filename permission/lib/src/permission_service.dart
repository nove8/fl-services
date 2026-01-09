import 'package:async/async.dart';
import 'package:permission_service/src/entity/permission.dart';
import 'package:permission_service/src/entity/permission_status.dart';
import 'package:permission_service/src/entity/service.dart';
import 'package:permission_service/src/entity/service_status.dart';

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

  /// Gets the status of the specified [service].
  ///
  /// Returns a [Result] containing the [ServiceStatus] (enabled, disabled, or not applicable).
  /// In case of error, a [GetServiceStatusFailure] will be returned as failure.
  Future<Result<ServiceStatus>> getServiceStatus(Service service);

  /// Checks whether the app should show a rationale for requesting the specified [permission].
  ///
  /// Returns a [Result] containing a boolean indicating if a rationale should be shown.
  /// This is typically true when the user has previously denied the permission.
  /// In case of error, a [CheckShouldShowRequestRationaleFailure] will be returned as failure.
  Future<Result<bool>> shouldShowRequestRationale(Permission permission);
}
