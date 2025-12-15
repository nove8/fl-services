import 'package:database_service/src/entity/database_order.dart';
import 'package:database_service/src/util/database_table_column_util.dart';
import 'package:database_service/src/util/object_util.dart';
import 'package:database_service/src/util/string_util.dart';
import 'package:sqflite/sqflite.dart';

/// Extension on [DatabaseExecutor] providing additional query capabilities.
extension DatabaseExecutorExtensions on DatabaseExecutor {
  /// Extended query method that supports additional ordering options.
  Future<List<Map<String, Object?>>> queryExtended(
    String tableName, {
    bool? isDistinct,
    List<String>? selectColumns,
    String? whereClause,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    assert(
      (orderByColumn == null && order == null) || orderByClauses == null,
      'Cannot provide both orderByColumn/order and orderByClauses',
    );

    final List<String>? resultingOrderByClauses =
        orderByClauses ?? orderByColumn?.toOrderPredicateClause(order).toList(isGrowable: false);

    return query(
      tableName,
      distinct: isDistinct,
      columns: selectColumns,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: resultingOrderByClauses?.joinWithCommaAndSpace(),
      limit: limit,
    );
  }
}

/// Extension methods for batch database operations.
extension BatchExtensions on Batch {
  /// Inserts all rows from [valuesIterable] into [tableName], ignoring conflicts.
  void insertAllOrIgnore(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    for (final Map<String, Object?> values in valuesIterable) {
      insert(
        tableName,
        values,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  /// Inserts a row from [values] into [tableName], replacing on conflicts.
  void insertOrReplace(
    Map<String, Object?> values, {
    required String tableName,
  }) {
    insert(
      tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Replaces all rows in [tableName] by deleting matching rows and inserting new ones.
  void replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
    String? where,
    List<Object?>? whereArgs,
  }) {
    delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
    insertAllOrIgnore(valuesIterable, tableName: tableName);
  }
}
