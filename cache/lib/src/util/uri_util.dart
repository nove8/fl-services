/// Extension methods on [Uri] for common checks.
extension UriExtension on Uri {
  /// Whether this URI uses an HTTP or HTTPS scheme.
  bool get isNetwork => isScheme('http') || isScheme('https');
}
