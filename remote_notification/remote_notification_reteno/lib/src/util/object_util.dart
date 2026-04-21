/// Extension methods for [Map].
extension MapExtensions<K, V> on Map<K, V> {
  /// Returns the value for [key] if it exists and is of type [R], otherwise null.
  R? getIfValueType<R>(K key) {
    final V? value = this[key];
    return value is R ? value : null;
  }
}
