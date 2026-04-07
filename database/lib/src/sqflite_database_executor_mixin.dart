import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service_executor.dart';
import 'package:database_service/src/entity/database_order.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/database_clause_util.dart';
import 'package:database_service/src/util/database_row_util.dart';
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
  Future<Result<List<Map<String, Object?>>>> select({
    required String tableName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    return sqfliteDatabaseExecutor
        .queryExtended(
          tableName,
          whereClause: whereClauses?.toPredicateClause(),
          whereArgs: whereArgs,
          orderByColumn: orderByColumn,
          order: order,
          orderByClauses: orderByClauses,
          limit: limit,
        )
        .mapToResult(SelectAllRowsDatabaseFailure.new);
  }

  @override
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
  }) {
    final String whereClause = '$targetColumnName ${targetValues.toInWithoutArgumentsClause()}';
    final List<Object?> whereArguments = targetValues.toUnmodifiableList();
    return targetValues.isNotEmpty
        ? sqfliteDatabaseExecutor
              .queryExtended(
                tableName,
                isDistinct: isDistinct,
                selectColumns: selectColumns,
                whereClause: <String?>[
                  whereClause,
                  ...?additionalWhereClauses,
                ].toPredicateClause(),
                whereArgs: whereArguments,
                orderByColumn: orderByColumn,
                order: order,
                orderByClauses: orderByClauses,
                limit: limit,
              )
              .mapToResult(SelectByColumnValuesDatabaseFailure.new)
        : <Map<String, Object?>>[].toFutureSuccessResult();
  }

  @override
  Future<Result<Set<T>>> selectDistinctValues<T>({
    required String tableName,
    required String valueColumnName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    return sqfliteDatabaseExecutor
        .queryExtended(
          tableName,
          isDistinct: true,
          selectColumns: <String>[valueColumnName],
          whereClause: whereClauses?.toPredicateClause(),
          whereArgs: whereArgs,
          orderByColumn: orderByColumn,
          order: order,
          orderByClauses: orderByClauses,
          limit: limit,
        )
        .mapToResult(SelectDistinctValuesDatabaseFailure.new)
        .toEntitiesSet();
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
