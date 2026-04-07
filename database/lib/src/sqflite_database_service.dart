import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/sqflite_database_executor_mixin.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/sqflite_database_service_transaction.dart';
import 'package:database_service/src/entity/database_migration_statements_provider.dart';
import 'package:database_service/src/entity/database_table.dart';
import 'package:database_service/src/database_service_transaction.dart';
import 'package:database_service/src/exception/transaction_database_exception.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/future_util.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Default implementation of [DatabaseService] using the sqflite package.
final class SqfliteDatabaseService with SqfliteDatabaseServiceExecutorMixin implements DatabaseService {
  const SqfliteDatabaseService._(this._database);

  static Completer<Result<SqfliteDatabaseService>>? _completer;

  final sqflite.Database _database;

  @override
  sqflite.DatabaseExecutor get sqfliteDatabaseExecutor => _database;

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
      final String databasePath = join(await sqflite.getDatabasesPath(), databaseName);
      final sqflite.Database database = await sqflite.openDatabase(
        databasePath,
        version: version,
        onConfigure: (sqflite.Database database) async {
          await database.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (sqflite.Database database, _) async {
          await _onCreate(
            database: database,
            tables: tables,
          );
        },
        // ignore:prefer-trailing-comma
        onUpgrade: (sqflite.Database database, int oldVersion, int newVersion) {
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
    required sqflite.Database database,
    required List<DatabaseTable> tables,
  }) async {
    final List<String> schemaList = tables.optimizedExpandToList((DatabaseTable table) => table.schemaList);
    final sqflite.Batch batch = database.batch();
    schemaList.forEach(batch.execute);
    await batch.commit(noResult: true);
  }

  static Future<void> _onUpgrade({
    required sqflite.Database database,
    required int oldVersion,
    required int newVersion,
    required List<DatabaseMigrationStatementsProvider> migrationStatementsProviders,
  }) async {
    final sqflite.Batch batch = database.batch();
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
  Future<Result<T>> transaction<T>(
    Future<Result<T>> Function(DatabaseServiceTransaction) action, {
    bool? isExclusive,
  }) {
    return _database
        .transaction(
          (sqflite.Transaction sqfliteTransaction) async {
            final DatabaseServiceTransaction transaction = SqfliteDatabaseServiceTransaction(sqfliteTransaction: sqfliteTransaction);
            final Result<T> actionResult = await action(transaction);
            return _handleTransactionActionResult(actionResult);
          },
          exclusive: isExclusive,
        )
        .mapToResult(TransactionDatabaseFailure.new);
  }

  T _handleTransactionActionResult<T>(Result<T> actionResult) {
    return actionResult.when(
      onSuccess: (T output) => output,
      onFailure: (Failure failure) {
        // `sqflite` lib handles the result of transaction with try/catch.
        // So, fot lib to rollback changes made in transaction before error,
        // we need to throw exception. `sqflite` doesn't use and support
        // `Result` from `async` api.
        throw TransactionDatabaseException(failure: failure);
      },
    );
  }
}
