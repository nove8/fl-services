import 'package:database_service/src/entity/base_database_executor.dart';
import 'package:database_service/src/entity/database_executor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/// Database transaction interface to use during a transaction
final class Transaction with BaseDatabaseExecutor implements DatabaseExecutor {
  /// Creates a [Transaction] instance.
  const Transaction({required sqflite.Transaction sqfliteTransaction})
    : _sqfliteTransaction = sqfliteTransaction;

  final sqflite.Transaction _sqfliteTransaction;

  @override
  sqflite.DatabaseExecutor get sqfliteDatabaseExecutor => _sqfliteTransaction;
}
