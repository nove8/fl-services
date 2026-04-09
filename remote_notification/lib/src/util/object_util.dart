/// Extension methods for nullable objects.
extension NullableObjectExtensions<T> on T {
  /// Applies the given function block to this value and returns the result.
  R let<R>(R Function(T) block) => block(this);

  /// Casts this object to the specified type [R].
  R castTo<R>() => this as R;
}

/// Extension methods for [Map].
extension MapExtensions<K, V> on Map<K, V> {
  /// Returns the value for [key] if it exists and is of type [R], otherwise null.
  R? getIfValueType<R>(K key) {
    final V? value = this[key];
    return value is R ? value : null;
  }
}
