/// The HTTP proxy configured in the device system settings.
final class SystemProxy {
  /// Creates an instance of [SystemProxy].
  const SystemProxy({required this.host, required this.port});

  /// Host of the proxy, either a name or an IP address.
  final String host;

  /// Port the proxy listens on.
  final int port;

  @override
  String toString() {
    return 'SystemProxy{host: $host, port: $port}';
  }
}
