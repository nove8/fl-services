import 'dart:io';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_service/src/entity/app_platform.dart';
import 'package:permission_service/src/entity/device_service.dart';
import 'package:permission_service/src/entity/device_service_status.dart';
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
  static const _ServiceStatusLibToDomainMapper _serviceStatusLibToDomainMapper =
      _ServiceStatusLibToDomainMapper();

  /// Requests the specified [permission] on the given [appPlatform].
  ///
  /// Returns a [Result] containing the [PermissionStatus]. If the permission is not required for the
  /// specified [appPlatform], a successful result of [PermissionStatus.granted] will be returned.
  /// In case of error, a [RequestPermissionFailure] will be returned as failure.
  @override
  Future<Result<PermissionStatus>> requestPermission(Permission permission) {
    return _makePermissionAction(
      permission,
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
  Future<Result<PermissionStatus>> getPermissionStatus(Permission permission) {
    return _makePermissionAction(
      permission,
      (ph.Permission permission) => permission.status,
      GetPermissionStatusFailure.new,
    );
  }

  @override
  Future<Result<DeviceServiceStatus>> getServiceStatus(DeviceService service) {
    return switch (service) {
      DeviceService.location => _getLocationServiceStatus(),
    };
  }

  @override
  Future<Result<bool>> shouldShowRequestRationale(Permission permission) {
    final ph.Permission libPermission = _permissionDomainToLibMapper.transform(permission);
    return libPermission.shouldShowRequestRationale.mapToResult(CheckShouldShowRequestRationaleFailure.new);
  }

  Future<Result<PermissionStatus>> _makePermissionAction(
    Permission permission,
    Future<ph.PermissionStatus> Function(ph.Permission) permissionAction,
    Failure Function(Object error) failureProvider,
  ) {
    return _hasPermission(permission).flatMapAsync((bool hasPermission) {
      if (hasPermission) {
        final ph.Permission libPermission = _permissionDomainToLibMapper.transform(permission);
        return permissionAction
            .call(libPermission)
            .mapToResult(failureProvider)
            .mapAsync(_permissionStatusLibToDomainMapper.transform);
      } else {
        return PermissionStatus.granted.toFutureSuccessResult();
      }
    });
  }

  Result<bool> _hasPermission(Permission permission) {
    return _determineAppPlatform().map((AppPlatform appPlatform) {
      return switch (permission) {
        Permission.appTrackingTransparency => appPlatform.isIos,
        Permission.cameraSystemExternal => !appPlatform.isAndroid,
        Permission.cameraPreviewInternal => true,
        Permission.location => true,
        Permission.locationAlways => true,
        Permission.notification => true,
        Permission.saveToStorage => !appPlatform.isAndroid,
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

  Future<Result<DeviceServiceStatus>> _getLocationServiceStatus() {
    return ph.Permission.location.serviceStatus
        .mapToResult(GetServiceStatusFailure.new)
        .mapAsync(_serviceStatusLibToDomainMapper.transform);
  }
}
