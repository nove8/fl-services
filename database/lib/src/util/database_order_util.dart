import 'package:database_service/src/entity/database_order.dart';

const String _orderAsc = 'ASC';
const String _orderDesc = 'DESC';

/// Extension methods for converting [DatabaseOrder] to SQL strings.
extension DatabaseOrderExtensions on DatabaseOrder {
  /// Converts this order to its SQL string representation (ASC or DESC).
  String toSqlString() {
    return switch (this) {
      DatabaseOrder.ascending => _orderAsc,
      DatabaseOrder.descending => _orderDesc,
    };
  }
}
