import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/object_util.dart';

/// Extension methods for mapping database rows to entities.
extension DatabaseRowsExtensions on Iterable<Map<String, Object?>> {
  /// Converts the first row to an entity by casting its first value to type [T].
  T? toEntityOrNull<T>() => mapToEntityOrNull<T?>(_getAndCastFirstValueFromRow);

  /// Maps the first row to an entity using the provided mapper function.
  T? mapToEntityOrNull<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return firstOrNull?.let(entityMapper);
  }

  T _getAndCastFirstValueFromRow<T>(Map<String, Object?> itemRow) => itemRow.values.first as T;
}

/// Extension methods for mapping future database row results to entity lists.
extension FutureResultDatabaseRowsExtensions on Future<Result<Iterable<Map<String, Object?>>>> {
  /// Maps all rows to a list of entities using the provided mapper function.
  Future<Result<List<T>>> mapToEntitiesList<T>(T Function(Map<String, Object?> itemRow) entityMapper) {
    return mapAsync((Iterable<Map<String, Object?>> rows) {
      return rows.mapToUnmodifiableList(entityMapper);
    });
  }
}
