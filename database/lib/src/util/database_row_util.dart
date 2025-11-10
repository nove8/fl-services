import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/object_util.dart';

/// Extension methods for mapping future database row results to entity lists.
extension FutureResultDatabaseRowsExtensions on Future<Result<Iterable<Map<String, Object?>>>> {
  /// Converts the first row to an entity by casting its first value to type [T].
  Future<Result<T?>> toEntityOrNull<T>() => mapToEntityOrNull<T?>(_getAndCastFirstValueFromRow);

  /// Converts all rows to a list of entities by casting values to type [T].
  Future<Result<List<T>>> toEntitiesList<T>() {
    return mapToEntities<T>(
      _getAndCastFirstValueFromRow,
    ).mapAsync((Iterable<T> entities) => entities.toUnmodifiableList());
  }

  /// Converts all rows to a set of entities by casting values to type [T].
  Future<Result<Set<T>>> toEntitiesSet<T>() {
    return mapToEntities<T>(
      _getAndCastFirstValueFromRow,
    ).mapAsync((Iterable<T> entities) => entities.toUnmodifiableSet());
  }

  /// Maps the first row to an entity using the provided mapper function.
  Future<Result<T?>> mapToEntityOrNull<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return mapAsync((Iterable<Map<String, Object?>> rows) => rows.firstOrNull?.let(entityMapper));
  }

  /// Maps all rows to a iterable of entities using the provided mapper function.
  Future<Result<Iterable<T>>> mapToEntities<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return mapAsync((Iterable<Map<String, Object?>> rows) => rows.map(entityMapper));
  }

  /// Maps all rows to a list of entities using the provided mapper function.
  Future<Result<List<T>>> mapToEntitiesList<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return mapToEntities(entityMapper).mapAsync((Iterable<T> entities) => entities.toUnmodifiableList());
  }

  /// Maps all rows to a set of entities using the provided mapper function.
  Future<Result<Set<T>>> mapToEntitiesSet<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return mapToEntities(entityMapper).mapAsync((Iterable<T> entities) => entities.toUnmodifiableSet());
  }

  T _getAndCastFirstValueFromRow<T>(Map<String, Object?> itemRow) => itemRow.values.first as T;
}
