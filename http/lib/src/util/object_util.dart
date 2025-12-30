/// Extension methods for nullable objects.
extension NullableObjectExtensions<T> on T {
  /// Wraps this value in a [Future] that completes immediately with the value.
  Future<T> toFuture() => Future<T>.value(this);

  /// Applies the given function block to this value and returns the result.
  R let<R>(R Function(T) block) => block(this);
}
