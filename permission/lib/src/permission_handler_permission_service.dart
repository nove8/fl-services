import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_service/src/entity/app_platform.dart';
import 'package:permission_service/src/entity/permission.dart';
import 'package:permission_service/src/entity/permission_status.dart';
import 'package:permission_service/src/failure/permission_failure.dart';
import 'package:permission_service/src/permission_service.dart';
import 'package:permission_service/src/util/future_util.dart';

part 'mapper/permission_handler_permission_mappers.dart';

/// Default implementation of [PermissionService] using the permission_handler package.
final class PermissionHandlerPermissionService implements PermissionService {
  /// Creates a [PermissionHandlerPermissionService].
  const PermissionHandlerPermissionService();

  static const _PermissionServiceToLibMapper _permissionDomainToLibMapper = _PermissionServiceToLibMapper();
  static const _PermissionStatusLibToServiceMapper _permissionStatusLibToDomainMapper =
      _PermissionStatusLibToServiceMapper();

  /// Requests the specified [permission] on the given [appPlatform].
  ///
  /// Returns a [Result] containing the [PermissionStatus]. If the permission is not required for the
  /// specified [appPlatform], a successful result of [PermissionStatus.granted] will be returned.
  /// In case of error, a [RequestPermissionFailure] will be returned as failure.
  @override
  Future<Result<PermissionStatus>> requestPermission(
    Permission permission, {
    required AppPlatform appPlatform,
  }) {
    return _makePermissionAction(
      permission,
      appPlatform,
      (ph.Permission permission) => permission.request(),
      RequestPermissionFailure.new,
    );
  }

  /// Gets the status of the specified [permission] on the given [appPlatform].
  ///
  /// Returns a [Result] containing the [PermissionStatus]. If the permission is not required for the
  /// specified [appPlatform], a successful result of [PermissionStatus.granted] will be returned.
  /// In case of error, a [GetPermissionStatusFailure] will be returned as failure.
  @override
  Future<Result<PermissionStatus>> getPermissionStatus(
    Permission permission, {
    required AppPlatform appPlatform,
  }) {
    return _makePermissionAction(
      permission,
      appPlatform,
      (ph.Permission permission) => permission.status,
      GetPermissionStatusFailure.new,
    );
  }

  Future<Result<PermissionStatus>> _makePermissionAction(
    Permission permission,
    AppPlatform appPlatform,
    Future<ph.PermissionStatus> Function(ph.Permission) permissionAction,
    Failure Function(Object error) failureProvider,
  ) {
    final bool hasPermissionOnPlatform = _hasPermissionOnPlatform(
      permission,
      appPlatform: appPlatform,
    );

    if (hasPermissionOnPlatform) {
      final ph.Permission libPermission = _permissionDomainToLibMapper.transform(permission);
      return permissionAction
          .call(libPermission)
          .mapToResult(failureProvider)
          .mapAsync(_permissionStatusLibToDomainMapper.transform);
    } else {
      return PermissionStatus.granted.toFutureSuccessResult();
    }
  }

  bool _hasPermissionOnPlatform(
    Permission permission, {
    required AppPlatform appPlatform,
  }) {
    return switch (permission) {
      Permission.appTrackingTransparency => appPlatform.isIos,
      Permission.camera => true,
      Permission.notification => true,
    };
  }
}
