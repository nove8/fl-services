import 'package:database_service/src/base_database_executor_mixin.dart';
import 'package:database_service/src/entity/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Database transaction implementation.
final class DatabaseTransaction with BaseDatabaseExecutorMixin implements Transaction {
  /// Creates a [Transaction] instance.
  const DatabaseTransaction({required sqflite.Transaction sqfliteTransaction})
    : _sqfliteTransaction = sqfliteTransaction;

  final sqflite.Transaction _sqfliteTransaction;

  @override
  sqflite.DatabaseExecutor get sqfliteDatabaseExecutor => _sqfliteTransaction;
}
