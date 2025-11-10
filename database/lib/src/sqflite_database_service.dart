import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/entity/database_migration_statements_provider.dart';
import 'package:database_service/src/entity/database_order.dart';
import 'package:database_service/src/entity/database_table.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/database_clause_util.dart';
import 'package:database_service/src/util/database_row_util.dart';
import 'package:database_service/src/util/database_util.dart';
import 'package:database_service/src/util/future_util.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Default implementation of [DatabaseService] using the sqflite package.
final class SqfliteDatabaseService implements DatabaseService {
  const SqfliteDatabaseService._(this._database);

  static Completer<Result<SqfliteDatabaseService>>? _completer;

  final Database _database;

  /// Creates and initializes a [SqfliteDatabaseService] instance.
  static Future<Result<SqfliteDatabaseService>> create({
    required String databaseName,
    required int version,
    required List<DatabaseTable> tables,
    required List<DatabaseMigrationStatementsProvider> migrationStatementsProviders,
  }) async {
    if (_completer == null) {
      final Completer<Result<SqfliteDatabaseService>> completer = Completer<Result<SqfliteDatabaseService>>();
      _completer = completer;

      final Result<SqfliteDatabaseService> databaseServiceResult = await _init(
        databaseName: databaseName,
        version: version,
        tables: tables,
        migrationStatementsProviders: migrationStatementsProviders,
      );
      completer.complete(databaseServiceResult);
    }

    return _completer!.future;
  }

  static Future<Result<SqfliteDatabaseService>> _init({
    required String databaseName,
    required int version,
    required List<DatabaseTable> tables,
    required List<DatabaseMigrationStatementsProvider> migrationStatementsProviders,
  }) async {
    try {
      final String databasePath = join(await getDatabasesPath(), databaseName);
      final Database database = await openDatabase(
        databasePath,
        version: version,
        onConfigure: (Database database) async {
          await database.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (Database database, _) async {
          await _onCreate(
            database: database,
            tables: tables,
          );
        },
        // ignore:prefer-trailing-comma
        onUpgrade: (Database database, int oldVersion, int newVersion) {
          return _onUpgrade(
            database: database,
            oldVersion: oldVersion,
            newVersion: newVersion,
            migrationStatementsProviders: migrationStatementsProviders,
          );
        },
      );
      return SqfliteDatabaseService._(database).toSuccessResult();
    } catch (error) {
      return OpenDatabaseFailure(error).toFailureResult();
    }
  }

  static Future<void> _onCreate({
    required Database database,
    required List<DatabaseTable> tables,
  }) async {
    final List<String> schemaList = tables.optimizedExpandToList((DatabaseTable table) => table.schemaList);
    final Batch batch = database.batch();
    schemaList.forEach(batch.execute);
    await batch.commit(noResult: true);
  }

  static Future<void> _onUpgrade({
    required Database database,
    required int oldVersion,
    required int newVersion,
    required List<DatabaseMigrationStatementsProvider> migrationStatementsProviders,
  }) async {
    final Batch batch = database.batch();
    for (int fromVersion = oldVersion; fromVersion < newVersion; fromVersion++) {
      final int toVersion = fromVersion + 1;
      final List<String> migrationStatements = migrationStatementsProviders
          .where((DatabaseMigrationStatementsProvider provider) => provider.databaseVersion == toVersion)
          .optimizedExpandToList((DatabaseMigrationStatementsProvider provider) {
            return provider.migrationStatements;
          });

      if (migrationStatements.isNotEmpty) {
        migrationStatements.forEach(batch.execute);
      } else {
        throw StateError('Missing DB migration from $fromVersion to $toVersion');
      }
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<Result<void>> insertAllOrIgnore(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    final Batch batch = _database.batch();
    batch.insertAllOrIgnore(valuesIterable, tableName: tableName);
    return batch.commit(noResult: true, continueOnError: true).mapToResult(InsertAllDatabaseFailure.new);
  }

  @override
  Future<Result<void>> replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    final Batch batch = _database.batch();
    batch.replaceAll(valuesIterable, tableName: tableName);
    return batch.commit(noResult: true, continueOnError: true).mapToResult(ReplaceAllDatabaseFailure.new);
  }

  @override
  Future<Result<int>> getCount({
    required String tableName,
    String? whereClause,
    List<Object?>? whereArguments,
  }) {
    final String query = 'SELECT $countSelectClause FROM $tableName ${whereClause.toWhereString()}';
    return rawQuery(
      query,
      arguments: whereArguments,
    ).toEntityOrNull<int>().flatMapNullValueAsyncToFailure(GetCountDatabaseFailure.new);
  }

  @override
  Future<Result<T?>> getMaxValue<T>({
    required String tableName,
    required String valueColumnName,
  }) {
    final String query = 'SELECT MAX($countSelectClause) FROM $tableName';
    return rawQuery(query).toEntityOrNull<T>().flatMapNullValueAsyncToFailure(GetCountDatabaseFailure.new);
  }

  @override
  Future<Result<List<Map<String, Object?>>>> rawQuery(
    String query, {
    List<Object?>? arguments,
  }) {
    return _database.rawQuery(query, arguments).mapToResult(RawQueryDatabaseFailure.new);
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
    return _database
        .queryExtended(
          tableName,
          whereClause: whereClauses?.toPredicateClause(),
          whereArgs: whereArgs,
          orderByColumn: orderByColumn,
          order: order,
          orderByClauses: orderByClauses,
          limit: limit,
        )
        .mapToResult(SelectAllDatabaseFailure.new);
  }

  @override
  Future<Result<List<Map<String, Object?>>>> selectByColumnValues({
    required String tableName,
    required String targetColumnName,
    required Set<Object> targetValues,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
  }) {
    final String whereClause = '$targetColumnName ${targetValues.toInWithoutArgumentsClause()}';
    final List<Object?> whereArguments = targetValues.toUnmodifiableList();
    return targetValues.isNotEmpty
        ? _database
              .queryExtended(
                tableName,
                whereClause: whereClause,
                whereArgs: whereArguments,
                orderByColumn: orderByColumn,
                order: order,
                orderByClauses: orderByClauses,
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
    return _database
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
    return _database
        .insert(
          tableName,
          values,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        )
        .then((int id) {
          return id > 0 ? id.toSuccessResult() : FailureResult(const InsertDatabaseFailure());
        });
  }

  @override
  Future<Result<void>> deleteByValue({
    required String tableName,
    required String valueColumnName,
    required Object? value,
  }) async {
    await _database.delete(
      tableName,
      where: '$valueColumnName = ?',
      whereArgs: <Object?>[value],
    );
    return emptyResult;
  }
}
