/// Extension methods for string iterables.
extension StringIterableExtensions on Iterable<String> {
  /// Joins strings with comma and space separator.
  String joinWithCommaAndSpace() => join(', ');
}
