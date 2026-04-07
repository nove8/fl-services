import 'package:database_service/src/database_service_transaction.dart';
import 'package:database_service/src/sqflite_database_executor_mixin.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Database transaction implementation.
final class SqfliteDatabaseServiceTransaction
    with SqfliteDatabaseServiceExecutorMixin
    implements DatabaseServiceTransaction {
  /// Creates a [DatabaseServiceTransaction] instance.
  const SqfliteDatabaseServiceTransaction({required sqflite.Transaction sqfliteTransaction})
    : _sqfliteTransaction = sqfliteTransaction;

  final sqflite.Transaction _sqfliteTransaction;

  @override
  sqflite.DatabaseExecutor get sqfliteDatabaseExecutor => _sqfliteTransaction;
}
