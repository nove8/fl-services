import 'package:async/async.dart';
import 'package:database_service/src/database_executor.dart';
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
  /// Always use chain of results, for final result of transaction to be returned.
  /// DO NOT do like that, to avoid missing transaction result:
  ///
  /// ```dart
  /// await transaction.delete(tableName: 'old_data');
  /// await transaction.insert(tableName: 'new_data', ...);
  /// return Result.success(null);
  /// ```
  /// DO like this instead:
  ///
  /// ```dart
  /// return transaction.delete(tableName: 'old_data').flatMapFuture((_) {
  ///   return transaction.insert(tableName: 'new_data', ...);
  /// });
  /// ```
  ///
  Future<Result<T>> transaction<T>(
    Future<Result<T>> Function(Transaction) action, {
    bool? isExclusive,
  });
}
