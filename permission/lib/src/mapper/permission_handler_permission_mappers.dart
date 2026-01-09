part of '../permission_handler_permission_service.dart';

final class _PermissionServiceToLibMapper {
  const _PermissionServiceToLibMapper();

  ph.Permission transform(Permission permission) {
    return switch (permission) {
      Permission.appTrackingTransparency => ph.Permission.appTrackingTransparency,
      Permission.cameraSystemExternal || Permission.cameraPreviewInternal => ph.Permission.camera,
      Permission.location => ph.Permission.location,
      Permission.locationAlways => ph.Permission.locationAlways,
      Permission.notification => ph.Permission.notification,
      Permission.saveToStorage => ph.Permission.storage,
    };
  }
}

final class _PermissionStatusLibToServiceMapper {
  const _PermissionStatusLibToServiceMapper();

  PermissionStatus transform(ph.PermissionStatus libStatus) {
    return switch (libStatus) {
      ph.PermissionStatus.granted => PermissionStatus.granted,
      ph.PermissionStatus.denied => PermissionStatus.denied,
      ph.PermissionStatus.permanentlyDenied => PermissionStatus.permanentlyDenied,
      ph.PermissionStatus.limited => PermissionStatus.limited,
      ph.PermissionStatus.restricted || ph.PermissionStatus.provisional => PermissionStatus.other,
    };
  }
}

final class _ServiceStatusLibToDomainMapper {
  const _ServiceStatusLibToDomainMapper();

  ServiceStatus transform(ph.ServiceStatus libStatus) {
    return switch (libStatus) {
      ph.ServiceStatus.disabled => ServiceStatus.disabled,
      ph.ServiceStatus.enabled => ServiceStatus.enabled,
      ph.ServiceStatus.notApplicable => ServiceStatus.notApplicable,
    };
  }
}
