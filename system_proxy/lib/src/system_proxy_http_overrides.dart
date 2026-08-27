import 'dart:io';

import 'package:system_proxy_service/src/entity/system_proxy.dart';

/// [HttpOverrides] that route every Dart HTTP request through [SystemProxy].
///
/// Certificate validation is disabled for all requests, because a debugging
/// proxy decrypts HTTPS traffic with its own certificate. Install the overrides
/// in test environments only:
///
/// ```dart
/// if (environment.isTest) {
///   final SystemProxyHttpOverrides? httpOverrides =
///       await systemProxyService.getHttpOverrides().outputOrNull;
///   if (httpOverrides != null) {
///     HttpOverrides.global = httpOverrides;
///   }
/// }
/// ```
final class SystemProxyHttpOverrides extends HttpOverrides {
  /// Creates an instance of [SystemProxyHttpOverrides].
  SystemProxyHttpOverrides(this._systemProxy);

  final SystemProxy _systemProxy;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      // ignore: prefer-trailing-comma
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    return 'PROXY ${_systemProxy.host}:${_systemProxy.port}';
  }
}
