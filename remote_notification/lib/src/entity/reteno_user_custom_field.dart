/// Represents a custom user field for Reteno user attributes.
final class RetenoUserCustomField {
  /// Creates a [RetenoUserCustomField] instance.
  const RetenoUserCustomField({
    required this.key,
    required this.value,
  });

  /// The key of the custom user field.
  final String key;

  /// The value of the custom user field.
  final String? value;

  @override
  String toString() {
    return 'RetenoUserCustomField{key: $key, value: $value}';
  }
}
