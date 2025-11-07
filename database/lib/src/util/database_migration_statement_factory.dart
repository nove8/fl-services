import 'package:database_service/src/util/database_argument_util.dart';

/// Factory for building database migration SQL statements.
abstract final class DatabaseMigrationStatementFactory {
  /// Builds an `ALTER TABLE ... ADD COLUMN ...` statement.
  ///
  /// - Appends `NOT NULL` when [isNullable] is `false`.
  /// - Appends `DEFAULT <value>` when [defaultValue] is provided. The value is
  /// formatted using `Object.formattedValue` to ensure proper SQL escaping.
  /// - Requires [defaultValue] when [isNullable] is `false`.
  static String addColumnStatement({
    required String tableName,
    required String columnName,
    required String type,
    required bool isNullable,
    Object? defaultValue,
  }) {
    assert(isNullable || defaultValue != null, 'Provide default value for not nullable columns');

    final StringBuffer clauseBuffer = StringBuffer(
      'ALTER TABLE $tableName ADD COLUMN $columnName $type',
    );
    if (!isNullable) {
      clauseBuffer.write(' NOT NULL');
    }
    if (defaultValue != null) {
      clauseBuffer.write(' DEFAULT ${defaultValue.formattedValue}');
    }
    return clauseBuffer.toString();
  }

  /// Builds an `ALTER TABLE ... ADD COLUMN INTEGER NOT NULL` statement with the provided [defaultValue].
  static String addIntegerColumnStatement({
    required String tableName,
    required String columnName,
    required int defaultValue,
  }) {
    return _addIntegerColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: false,
      defaultValue: defaultValue,
    );
  }

  /// Builds an `ALTER TABLE ... ADD COLUMN INTEGER` statement that allows `NULL` values.
  static String addIntegerNullableColumnStatement({
    required String tableName,
    required String columnName,
  }) {
    return _addIntegerColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: true,
    );
  }

  static String _addIntegerColumn({
    required String tableName,
    required String columnName,
    required bool isNullable,
    int? defaultValue,
  }) {
    return addColumnStatement(
      tableName: tableName,
      columnName: columnName,
      type: 'INTEGER',
      isNullable: isNullable,
      defaultValue: defaultValue,
    );
  }
}
