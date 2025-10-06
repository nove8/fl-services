import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/entity/database_entity.dart';

/// Extension methods for [DatabaseService] with entity-based operations.
extension DatabaseServiceUtil on DatabaseService {
  /// Inserts entities into the database, ignoring conflicts.
  Future<Result<void>> insertEntities(
    Iterable<DatabaseEntity> entities, {
    required String tableName,
  }) {
    final Iterable<Map<String, Object?>> values = _obtainValues(entities);
    return insertAllOrIgnore(values, tableName: tableName);
  }

  /// Replaces entities in the database.
  Future<Result<void>> replaceEntities(
    Iterable<DatabaseEntity> entities, {
    required String tableName,
  }) {
    final Iterable<Map<String, Object?>> values = _obtainValues(entities);
    return replaceAll(values, tableName: tableName);
  }

  /// Checks if the table has any rows matching the optional where clause.
  Future<Result<bool>> hasRows({
    required String tableName,
    String? whereClause,
    List<Object?>? whereArguments,
  }) {
    return getCount(
      tableName: tableName,
      whereClause: whereClause,
      whereArguments: whereArguments,
    ).mapAsync((int count) => count > 0);
  }

  Iterable<Map<String, Object?>> _obtainValues(Iterable<DatabaseEntity> entities) {
    return entities.map((DatabaseEntity entity) => entity.toMap());
  }
}
