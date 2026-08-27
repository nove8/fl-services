part of '../system_proxy_service_impl.dart';

/// Mapper that transforms the platform arguments to [SystemProxy].
final class _SystemProxyMapper {
  /// Creates a [_SystemProxyMapper].
  const _SystemProxyMapper();

  // Params
  static const String _hostParam = 'host';
  static const String _portParam = 'port';

  /// Transforms the platform [arguments] to [SystemProxy],
  /// or to `null` when the platform reports no proxy.
  SystemProxy? transform(Map<Object?, Object?> arguments) {
    final Object? host = arguments[_hostParam];
    final Object? port = arguments[_portParam];

    return host is String && host.isNotEmpty && port is int ? SystemProxy(host: host, port: port) : null;
  }
}
