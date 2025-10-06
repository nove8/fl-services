import 'package:sqflite/sqflite.dart';

/// Extension methods for batch database operations.
extension BatchExtensions on Batch {
  /// Inserts all rows from [valuesIterable] into [tableName], ignoring conflicts.
  void insertAllOrIgnore(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
  }) {
    for (final Map<String, Object?> values in valuesIterable) {
      insert(
        tableName,
        values,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  /// Replaces all rows in [tableName] by deleting matching rows and inserting new ones.
  void replaceAll(
    Iterable<Map<String, Object?>> valuesIterable, {
    required String tableName,
    String? where,
    List<Object?>? whereArgs,
  }) {
    delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
    insertAllOrIgnore(valuesIterable, tableName: tableName);
  }
}
