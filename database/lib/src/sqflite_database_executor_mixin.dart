import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service_executor.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/database_clause_util.dart';
import 'package:database_service/src/util/database_util.dart';
import 'package:database_service/src/util/future_util.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Sqflite implementation of [DatabaseServiceExecutor] methods.
base mixin SqfliteDatabaseServiceExecutorMixin implements DatabaseServiceExecutor {
  /// The underlying sqflite database executor instance.
  @protected
  sqflite.DatabaseExecutor get sqfliteDatabaseExecutor;

  @override
  Future<Result<void>> insertAllOrIgnore(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    final sqflite.Batch batch = sqfliteDatabaseExecutor.batch();
    batch.insertAllOrIgnore(valuesIterable, tableName: tableName);
    return batch.commit(noResult: true, continueOnError: true).mapToResult(InsertAllDatabaseFailure.new);
  }

  @override
  Future<Result<void>> insertOrReplace(Map<String, Object?> values, {required String tableName}) {
    return sqfliteDatabaseExecutor
        .insert(
          tableName,
          values,
          conflictAlgorithm: .replace,
        )
        .mapToResult(InsertOrReplaceDatabaseFailure.new);
  }

  @override
  Future<Result<void>> replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    final sqflite.Batch batch = sqfliteDatabaseExecutor.batch();
    batch.replaceAll(valuesIterable, tableName: tableName);
    return batch.commit(noResult: true, continueOnError: true).mapToResult(ReplaceAllDatabaseFailure.new);
  }

  @override
  Future<Result<List<Map<String, Object?>>>> rawQuery(
    String query, {
    List<Object?>? arguments,
  }) {
    return sqfliteDatabaseExecutor.rawQuery(query, arguments).mapToResult(RawQueryDatabaseFailure.new);
  }

  @override
  Future<Result<int>> insertOrIgnoreValuesWithIdResult(
    Map<String, Object?> values, {
    required String tableName,
  }) {
    return sqfliteDatabaseExecutor
        .insert(
          tableName,
          values,
          conflictAlgorithm: .ignore,
        )
        .then((int id) {
          return id > 0 ? id.toSuccessResult() : FailureResult(const InsertDatabaseFailure());
        });
  }

  @override
  Future<Result<void>> delete({
    required String tableName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
  }) {
    return sqfliteDatabaseExecutor
        .delete(
          tableName,
          where: whereClauses?.toPredicateClause(),
          whereArgs: whereArgs,
        )
        .mapToResult(DeleteDatabaseFailure.new);
  }

  @override
  Future<Result<void>> updateOrIgnoreValues(
    Map<String, Object?> values, {
    required String tableName,
    required List<String> whereClauses,
    List<Object?>? whereArgs,
  }) {
    return sqfliteDatabaseExecutor
        .update(
          tableName,
          values,
          where: whereClauses.toPredicateClause(),
          whereArgs: whereArgs,
          conflictAlgorithm: .ignore,
        )
        .mapToResult(UpdateOrIgnoreValuesDatabaseFailure.new);
  }
}
