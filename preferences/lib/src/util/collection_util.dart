/// Extension on [Iterable] providing utility methods for creating unmodifiable collections.
extension IterableExtension<E> on Iterable<E> {
  /// Creates an unmodifiable list from this iterable.
  List<E> toUnmodifiableList() => List<E>.unmodifiable(this);

  /// Creates an unmodifiable set from this iterable.
  Set<E> toUnmodifiableSet() => Set<E>.unmodifiable(this);
}
