import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:system_proxy_service/src/system_proxy_http_overrides.dart';
import 'package:system_proxy_service/src/system_proxy_service.dart';

/// Extension methods for [SystemProxyService] with [SystemProxyHttpOverrides] support.
extension SystemProxyServiceUtil on SystemProxyService {
  /// Returns [SystemProxyHttpOverrides] for the proxy from the system settings,
  /// or `null` when the device has no proxy configured.
  ///
  /// The overrides are not installed by the service, the caller has to assign
  /// them to `HttpOverrides.global`. The overrides disable certificate
  /// validation, so install them in test environments only.
  Future<Result<SystemProxyHttpOverrides?>> getHttpOverrides() {
    return getSystemProxy().mapNotNullValueAsync(SystemProxyHttpOverrides.new);
  }
}
