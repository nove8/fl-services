/// Extension methods for [Iterable] collections.
extension IterableExtension<E> on Iterable<E> {
  /// Returns the index of the last item in the list or -1 if the list is empty.
  int get lastIndex => length - 1;

  /// Maps elements to type [R] and returns an unmodifiable list.
  List<R> mapToUnmodifiableList<R>(R Function(E element) transform) {
    return map(transform).toUnmodifiableList();
  }

  /// Converts this iterable to an unmodifiable list.
  List<E> toUnmodifiableList() => List<E>.unmodifiable(this);

  /// Converts this iterable to an unmodifiable set.
  Set<E> toUnmodifiableSet() => Set<E>.unmodifiable(this);
}

/// Extension methods for expanding [Iterable] collections.
extension IterableIterableExtension<E> on Iterable<E> {
  /// Expands elements and returns a flat list using optimized for-in syntax.
  List<T> optimizedExpandToList<T>(Iterable<T> Function(E element) toElements) {
    return <T>[for (final E element in this) ...toElements(element)];
  }
}
