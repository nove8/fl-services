/// Extension methods for nullable objects.
extension NullableObjectExtensions<T> on T {
  /// Applies the given function block to this value and returns the result.
  R let<R>(R Function(T) block) => block(this);

  /// Casts this object to the specified type [R].
  R castTo<R>() => this as R;
}
