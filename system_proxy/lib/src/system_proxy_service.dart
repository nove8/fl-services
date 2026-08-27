import 'package:async/async.dart';
import 'package:system_proxy_service/src/entity/system_proxy.dart';

/// Service that reports the HTTP proxy configured in the device system settings.
abstract interface class SystemProxyService {
  /// Returns the HTTP proxy from the system settings, or `null` when the device has no proxy configured.
  Future<Result<SystemProxy?>> getSystemProxy();
}
