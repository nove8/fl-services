import 'package:common_result/common_result.dart';

/// Service exception to rollback transaction in case transaction result is failure.
final class TransactionDatabaseException implements Exception {
  /// Creates a [TransactionDatabaseException].
  const TransactionDatabaseException({required this.failure});

  /// Failure that causes this exception throw.
  final Failure failure;
}
