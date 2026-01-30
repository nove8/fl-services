import 'package:common_result/common_result.dart';

/// Base class for database failures
sealed class DatabaseFailure implements Failure {}

/// Failure that occurs when opening a database.
final class OpenDatabaseFailure implements DatabaseFailure {
  /// Creates an [OpenDatabaseFailure] with the underlying error.
  const OpenDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'OpenDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when inserting multiple rows into a database.
final class InsertAllDatabaseFailure implements DatabaseFailure {
  /// Creates an [InsertAllDatabaseFailure] with the underlying error.
  const InsertAllDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'InsertAllDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when inserting or replacing a row into a database.
final class InsertOrReplaceDatabaseFailure implements DatabaseFailure {
  /// Creates an [InsertOrReplaceDatabaseFailure] with the underlying error.
  const InsertOrReplaceDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'InsertOrReplaceDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when replacing multiple rows in a database.
final class ReplaceAllDatabaseFailure implements DatabaseFailure {
  /// Creates a [ReplaceAllDatabaseFailure] with the underlying error.
  const ReplaceAllDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'ReplaceAllDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when getting the row count from a database table.
final class GetCountDatabaseFailure implements DatabaseFailure {
  /// Creates a [GetCountDatabaseFailure].
  const GetCountDatabaseFailure();
}

/// Failure that occurs when executing a raw SQL query.
final class RawQueryDatabaseFailure implements DatabaseFailure {
  /// Creates a [RawQueryDatabaseFailure] with the underlying error.
  const RawQueryDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'RawQueryDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when selecting all rows.
final class SelectAllRowsDatabaseFailure implements DatabaseFailure {
  /// Creates a [SelectAllRowsDatabaseFailure] with the underlying error.
  const SelectAllRowsDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'SelectAllDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when selecting rows by column values.
final class SelectByColumnValuesDatabaseFailure implements DatabaseFailure {
  /// Creates a [SelectByColumnValuesDatabaseFailure] with the underlying error.
  const SelectByColumnValuesDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'SelectByColumnValuesDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when selecting distinct rows.
final class SelectDistinctValuesDatabaseFailure implements DatabaseFailure {
  /// Creates a [SelectDistinctValuesDatabaseFailure] with the underlying error.
  const SelectDistinctValuesDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'SelectDistinctValuesDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when inserting a row into a database.
final class InsertDatabaseFailure implements DatabaseFailure {
  /// Creates an [InsertDatabaseFailure].
  const InsertDatabaseFailure();
}

/// Failure that occurs when updating or ignoring values in the database.
final class UpdateOrIgnoreValuesDatabaseFailure implements DatabaseFailure {
  /// Creates a [UpdateOrIgnoreValuesDatabaseFailure] with the underlying error.
  const UpdateOrIgnoreValuesDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'UpdateOrIgnoreValuesDatabaseFailure{error: $error}';
  }
}

/// Failure that occurs when deleting rows from a database.
final class DeleteDatabaseFailure implements DatabaseFailure {
  /// Creates a [DeleteDatabaseFailure] with the underlying error.
  const DeleteDatabaseFailure(this.error);

  /// The underlying error object from the database operation.
  final Object error;

  @override
  String toString() {
    return 'DeleteDatabaseFailure{error: $error}';
  }
}
