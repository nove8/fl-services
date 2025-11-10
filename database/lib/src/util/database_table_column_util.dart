import 'package:database_service/src/entity/database_order.dart';

/// Extension methods for building ORDER BY clauses from column names.
extension DatabaseTableColumnExtensions on String {
  /// Converts this column name to an ORDER BY predicate clause with the specified order.
  String toOrderPredicateClause([DatabaseOrder? order]) {
    final DatabaseOrder resultOrder = order ?? DatabaseOrder.ascending;
    return '$this ${resultOrder.sqlString}';
  }
}
