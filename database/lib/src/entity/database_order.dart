/// The sort order for database query results.
enum DatabaseOrder {
  /// Ascending order.
  ascending('ASC'),

  /// Descending order.
  descending('DESC');

  /// Creates a [DatabaseOrder] with its SQL representation.
  const DatabaseOrder(this.sqlString);

  /// The SQL string representation of this order.
  final String sqlString;
}
