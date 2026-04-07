import 'dart:async';

import 'package:async/async.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/database_service_transaction.dart';
/// Common interface for database operations for [DatabaseService] and [DatabaseServiceTransaction]
abstract interface class DatabaseServiceExecutor {
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

  /// Inserts a row into [tableName], returning the row ID, or ignores on conflict.
  Future<Result<int>> insertOrIgnoreValuesWithIdResult(
    Map<String, Object?> values, {
    required String tableName,
  });

  /// Deletes rows from [tableName] where [whereClauses] and [whereArgs] match.
  Future<Result<void>> delete({
    required String tableName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
  });

  /// Updates rows in [tableName] with [values] where [whereClauses] match, or ignores if no rows match.
  Future<Result<void>> updateOrIgnoreValues(
    Map<String, Object?> values, {
    required String tableName,
    required List<String> whereClauses,
    List<Object?>? whereArgs,
  });
}
