/// Extension methods for converting boolean values to database integers.
extension DatabaseBoolExtensions on bool {
  /// Converts a boolean to an integer (1 for true, 0 for false).
  int toInt() => this ? 1 : 0;
}
