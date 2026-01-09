import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/entity/database_entity.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/database_clause_util.dart';
import 'package:database_service/src/util/database_row_util.dart';
import 'package:database_service/src/util/object_util.dart';

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

  /// Inserts the [entity] into its table or replaces the existing row
  Future<Result<void>> insertOrReplaceEntity(DatabaseEntity entity) {
    return insertOrReplace(
      entity.toMap(),
      tableName: entity.tableName,
    );
  }

  /// Gets the row count from [tableName] matching the optional where clause.
  Future<Result<int>> getCount({
    required String tableName,
    String? whereClause,
    List<Object?>? whereArguments,
  }) {
    final String query = 'SELECT $countSelectClause FROM $tableName ${whereClause.toWhereString()}';
    return rawQuery(
      query,
      arguments: whereArguments,
    ).toEntityOrNull<int>().flatMapNullValueAsyncToFailure(GetCountDatabaseFailure.new);
  }

  /// Gets the maximum value of [valueColumnName] from [tableName].
  Future<Result<T?>> getMaxValue<T>({
    required String tableName,
    required String valueColumnName,
  }) {
    final String query = 'SELECT MAX($valueColumnName) FROM $tableName';
    return rawQuery(query).toEntityOrNull<T>();
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

  /// Selects a single value of type [T] from [valueColumnName] in [tableName] where [targetColumnName] equals [targetValue].
  Future<Result<T?>> selectValueByColumnValue<T>({
    required String tableName,
    required String targetColumnName,
    required Object targetValue,
    required String valueColumnName,
    List<String?>? additionalWhereClauses,
  }) {
    return selectByColumnValues(
      tableName: tableName,
      targetColumnName: targetColumnName,
      targetValues: targetValue.toSet(),
      selectColumns: valueColumnName.toList(),
      additionalWhereClauses: additionalWhereClauses,
      limit: 1,
    ).toEntityOrNull<T>();
  }

  Iterable<Map<String, Object?>> _obtainValues(Iterable<DatabaseEntity> entities) {
    return entities.map((DatabaseEntity entity) => entity.toMap());
  }
}
