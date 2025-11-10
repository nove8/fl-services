/// Operators for combining SQL predicate clauses.
enum DatabasePredicateOperator {
  /// AND operator.
  and('AND'),

  /// OR operator.
  or('OR');

  /// Creates a [DatabasePredicateOperator] with its SQL representation.
  const DatabasePredicateOperator(this.sqlString);

  /// The SQL string representation of this operator.
  final String sqlString;
}
