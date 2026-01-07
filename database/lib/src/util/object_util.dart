/// Extension methods for nullable objects.
extension NullableObjectExtensions<T> on T {
  /// Applies the given function block to this value and returns the result.
  R let<R>(R Function(T) block) => block(this);

  /// Converts this value to a list containing a single element.
  List<T> toList({bool isGrowable = true}) {
    return List<T>.filled(
      1,
      this,
      growable: isGrowable,
    );
  }

  /// Converts this value to a set containing a single element.
  Set<T> toSet() => <T>{this};
}
