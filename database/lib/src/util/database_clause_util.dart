import 'package:collection/collection.dart';
import 'package:database_service/src/util/collection_util.dart';
import 'package:database_service/src/util/constants.dart';
import 'package:database_service/src/util/database_argument_util.dart';
import 'package:database_service/src/util/string_util.dart';

/// SQL clause for counting rows.
const String countSelectClause = 'COUNT(*)';

/// Utility class for building SQL clauses.
abstract final class DatabaseClauseUtil {
  /// Builds a `CASE ... END` expression for `ORDER BY` to preserve the exact order
  /// provided in [values].
  /// Unlisted [values] are placed at the end via `ELSE`.
  /// Returns an empty string when [values] is empty.
  static String buildOrderByValuesClause({
    required String valueColumnName,
    required Iterable<Object> values,
  }) {
    if (values.isNotEmpty) {
      final StringBuffer clauseBuffer = StringBuffer('CASE $valueColumnName');
      values.forEachIndexed((int valueIndex, Object value) {
        clauseBuffer.write(' WHEN ${value.formattedValue} THEN $valueIndex');
      });
      clauseBuffer.write(' ELSE ${values.lastIndex + 1}');
      clauseBuffer.write(' END');

      return clauseBuffer.toString();
    } else {
      return emptyString;
    }
  }
}

/// Extension methods for building SQL clauses from nullable objects.
extension ClauseExtensions on Object? {
  /// Converts this value to a WHERE clause string.
  String toWhereString() => toSqlString('WHERE');

  /// Converts this value to an ORDER BY clause string.
  String toOrderByString() => toSqlString('ORDER BY');

  /// Converts this value to an SQL clause string with the given command.
  String toSqlString(String command) {
    final Object? value = this;
    return value != null && (value is! String || value.isNotEmpty)
        ? value is String && value.toUpperCase().startsWith(command)
              ? value
              : '$command $this'
        : emptyString;
  }
}

/// Extension methods for building IN clauses from object lists.
extension ObjectListClausesExtensions on Iterable<Object> {
  /// For list with 3 elements returns 'IN (?, ?, ?)' clause.
  String? toInWithoutArgumentsClause() {
    final List<String> argumentPatterns = List<String>.filled(length, '?');
    return _toInArgumentsClause(arguments: argumentPatterns);
  }

  String? _toInArgumentsClause({required Iterable<String> arguments}) {
    final String formattedArguments = arguments.joinWithCommaAndSpace();
    return isNotEmpty ? 'IN ($formattedArguments)' : null;
  }
}
