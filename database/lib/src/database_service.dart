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

  /// Inserts a row from [values] into [tableName], replacing on conflicts.
  Future<Result<void>> insertOrReplace(
    Map<String, Object?> values, {
    required String tableName,
  });

  /// Replaces all rows from [valuesIterable] in [tableName].
  Future<Result<void>> replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  });

  /// Executes a raw SQL query with optional arguments.
  Future<Result<List<Map<String, Object?>>>> rawQuery(
    String query, {
    List<Object?>? arguments,
  });

  /// Selects all rows from [tableName].
  Future<Result<List<Map<String, Object?>>>> select({
    required String tableName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  });

  /// Selects rows from [tableName] where [targetColumnName] matches any value in [targetValues].
  Future<Result<List<Map<String, Object?>>>> selectByColumnValues({
    required String tableName,
    required String targetColumnName,
    required Set<Object> targetValues,
    bool? isDistinct,
    List<String>? selectColumns,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
    List<String?>? additionalWhereClauses,
  });

  /// Selects distinct values of [valueColumnName] from [tableName].
  Future<Result<Set<T>>> selectDistinctValues<T>({
    required String tableName,
    required String valueColumnName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
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
