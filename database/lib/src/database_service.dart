import 'package:async/async.dart';
import 'package:database_service/src/entity/database_executor.dart';
import 'package:database_service/src/entity/transaction.dart';

/// A service interface for database operations.
abstract interface class DatabaseService implements DatabaseExecutor {
  /// Calls in action must only be done using the transaction object.
  /// Using the database service will trigger a dead-lock.
  ///
  /// [isExclusive] controls the transaction lock level. When `true` it
  /// prevents all other database connections from reading or writing.
  /// When `false` or `null` (default), it allow reads but prevent writes
  /// from other connections.
  ///
  Future<Result<T>> transaction<T>(
    Future<T> Function(Transaction txn) action, {
    bool? isExclusive,
  });
}
