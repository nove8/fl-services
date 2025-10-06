import 'dart:async';

import 'package:async/async.dart';
import 'package:database_service/src/entity/database_order.dart';

/// A service interface for database operations.
abstract interface class DatabaseService {
  /// Inserts all rows from [valuesIterable] into [tableName], ignoring conflicts.
  Future<Result<void>> insertAllOrIgnore(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  });

  /// Replaces all rows from [valuesIterable] in [tableName].
  Future<Result<void>> replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  });

  /// Gets the row count from [tableName] matching the optional where clause.
  Future<Result<int>> getCount({
    required String tableName,
    String? whereClause,
    List<Object?>? whereArguments,
  });

  /// Executes a raw SQL query with optional arguments.
  Future<Result<List<Map<String, Object?>>>> rawQuery(
    String query, {
    List<Object?>? arguments,
  });

  /// Selects rows from [tableName] where [targetColumnName] matches any value in [targetValues].
  Future<Result<List<Map<String, Object?>>>> selectByColumnValues({
    required String tableName,
    required String targetColumnName,
    required Set<Object> targetValues,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
  });

  /// Inserts a row into [tableName], returning the row ID, or ignores on conflict.
  Future<Result<int>> insertOrIgnoreValuesWithIdResult(
    Map<String, Object?> values, {
    required String tableName,
  });

  /// Deletes rows from [tableName] where [valueColumnName] equals [value].
  Future<Result<void>> deleteByValue({
    required String tableName,
    required String valueColumnName,
    required Object? value,
  });
}
