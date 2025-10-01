/// Extensions on [Iterable].
extension IterableExtension<E> on Iterable<E> {
  /// Creates an unmodifiable [List] from this iterable.
  List<E> toUnmodifiableList() => List<E>.unmodifiable(this);

  /// Creates an unmodifiable [Set] from this iterable.
  Set<E> toUnmodifiableSet() => Set<E>.unmodifiable(this);

  /// Returns the number of elements matching the given [predicate].
  int count(bool Function(E) predicate) {
    if (isEmpty) {
      return 0;
    }
    int count = 0;
    for (final E element in this) {
      if (predicate(element)) {
        count++;
      }
    }
    return count;
  }

  /// Maps [this] iterable to a list of non-null values using [transform] function.
  List<R> mapNotNullToList<R>(R? Function(E element) transform) {
    final List<R> destination = <R>[];
    _mapNotNull(transform, destination.add);
    return destination;
  }

  void _mapNotNull<R>(R? Function(E) transform, void Function(R) addElement) {
    for (final E element in this) {
      final R? transformed = transform(element);
      if (transformed != null) {
        addElement.call(transformed);
      }
    }
  }
}

/// Extensions on [List].
extension ListExtensions<E> on List<E> {
  /// Returns the second element from this list.
  E get second => this[1];
}
