import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/database_service.dart';
import 'package:database_service/src/database_service_executor.dart';
import 'package:database_service/src/entity/database_entity.dart';
import 'package:database_service/src/entity/database_order.dart';
import 'package:database_service/src/failure/database_failure.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/database_clause_util.dart';
import 'package:database_service/src/util/database_row_util.dart';
import 'package:database_service/src/util/database_table_column_util.dart';
import 'package:database_service/src/util/object_util.dart';
import 'package:database_service/src/util/string_util.dart';

/// Extension methods for [DatabaseService] with entity-based operations.
extension DatabaseServiceExecutorUtil on DatabaseServiceExecutor {
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

  /// Selects rows from [tableName] with optional filtering, ordering, and column selection.
  Future<Result<List<Map<String, Object?>>>> select({
    required String tableName,
    bool? isDistinct,
    List<String>? selectColumns,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    final String query = _obtainSelectQuery(
      tableName: tableName,
      isDistinct: isDistinct,
      selectColumns: selectColumns,
      whereClauses: whereClauses,
      orderByColumn: orderByColumn,
      order: order,
      orderByClauses: orderByClauses,
      limit: limit,
    );

    return rawQuery(
      query,
      arguments: whereArgs,
    );
  }

  /// Selects rows from [tableName] where [targetColumnName] matches any value in [targetValues].
  Future<Result<List<Map<String, Object?>>>> selectByColumnValues({
    required String tableName,
    required String targetColumnName,
    required Set<Object> targetValues,
    bool? isDistinct,
    List<String>? selectColumns,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
    List<String?>? additionalWhereClauses,
  }) {
    if (targetValues.isEmpty) {
      return <Map<String, Object?>>[].toFutureSuccessResult();
    }

    final String inClause = '$targetColumnName ${targetValues.toInWithoutArgumentsClause()}';

    return select(
      tableName: tableName,
      isDistinct: isDistinct,
      selectColumns: selectColumns,
      whereClauses: <String?>[inClause, ...?additionalWhereClauses],
      whereArgs: targetValues.toUnmodifiableList(),
      orderByColumn: orderByColumn,
      order: order,
      orderByClauses: orderByClauses,
      limit: limit,
    );
  }

  /// Selects distinct values of [valueColumnName] from [tableName].
  Future<Result<Set<T>>> selectDistinctValues<T>({
    required String tableName,
    required String valueColumnName,
    List<String?>? whereClauses,
    List<Object?>? whereArgs,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    return select(
      tableName: tableName,
      isDistinct: true,
      selectColumns: <String>[valueColumnName],
      whereClauses: whereClauses,
      whereArgs: whereArgs,
      orderByColumn: orderByColumn,
      order: order,
      orderByClauses: orderByClauses,
      limit: limit,
    ).toEntitiesSet();
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

  /// Deletes rows from [tableName] where [valueColumnName] equals [value].
  Future<Result<void>> deleteByValue({
    required String tableName,
    required String valueColumnName,
    required Object? value,
  }) {
    return delete(
      tableName: tableName,
      whereClauses: <String?>['$valueColumnName = ?'],
      whereArgs: <Object?>[value],
    );
  }

  Iterable<Map<String, Object?>> _obtainValues(Iterable<DatabaseEntity> entities) {
    return entities.map((DatabaseEntity entity) => entity.toMap());
  }

  String _obtainSelectQuery({
    required String tableName,
    bool? isDistinct,
    List<String>? selectColumns,
    List<String?>? whereClauses,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    final StringBuffer queryStringBuffer = StringBuffer('SELECT');

    final String? distinctString = _buildDistinctString(isDistinct: isDistinct);
    final String columnsString = _buildColumnsString(selectColumns: selectColumns);

    if (distinctString != null) {
      queryStringBuffer.write(' $distinctString');
    }
    queryStringBuffer.write(' $columnsString FROM $tableName');

    _writeClausesToSelectQueryStringBuffer(
      queryStringBuffer,
      whereClauses: whereClauses,
      orderByColumn: orderByColumn,
      order: order,
      orderByClauses: orderByClauses,
      limit: limit,
    );

    return queryStringBuffer.toString();
  }

  String? _buildDistinctString({required bool? isDistinct}) {
    return isDistinct != null && isDistinct ? 'DISTINCT' : null;
  }

  String _buildColumnsString({required List<String>? selectColumns}) {
    return selectColumns?.joinWithCommaAndSpace() ?? '*';
  }

  StringBuffer _writeClausesToSelectQueryStringBuffer(
    StringBuffer queryStringBuffer, {
    List<String?>? whereClauses,
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
    int? limit,
  }) {
    final String? whereString = _buildWhereString(whereClauses: whereClauses);
    final String? orderByString = _buildOrderByString(
      orderByColumn: orderByColumn,
      order: order,
      orderByClauses: orderByClauses,
    );
    final String? limitString = _buildLimitString(limit: limit);

    if (whereString != null && whereString.isNotEmpty) {
      queryStringBuffer.write(' $whereString');
    }
    if (orderByString != null && orderByString.isNotEmpty) {
      queryStringBuffer.write(' $orderByString');
    }
    if (limitString != null) {
      queryStringBuffer.write(' $limitString');
    }

    return queryStringBuffer;
  }

  String? _buildWhereString({required List<String?>? whereClauses}) {
    return whereClauses?.toPredicateClause().toWhereString();
  }

  String? _buildOrderByString({
    String? orderByColumn,
    DatabaseOrder? order,
    List<String>? orderByClauses,
  }) {
    final List<String>? resultingClauses =
        orderByClauses ?? orderByColumn?.toOrderPredicateClause(order).toList(isGrowable: false);
    return resultingClauses?.joinWithCommaAndSpace().toOrderByString();
  }

  String? _buildLimitString({required int? limit}) {
    return limit != null ? 'LIMIT $limit' : null;
  }
}
