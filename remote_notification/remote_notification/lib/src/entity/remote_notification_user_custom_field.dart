/// Represents a custom user field for remote notification user attributes.
final class RemoteNotificationUserCustomField {
  /// Creates a [RemoteNotificationUserCustomField] instance.
  const RemoteNotificationUserCustomField({
    required this.key,
    required this.value,
  });

  /// The key of the custom user field.
  final String key;

  /// The value of the custom user field.
  final String? value;

  @override
  String toString() {
    return 'RemoteNotificationUserCustomField{key: $key, value: $value}';
  }
}
