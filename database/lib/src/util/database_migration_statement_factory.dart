import 'package:database_service/src/util/constants.dart';
import 'package:database_service/src/util/database_argument_util.dart';
import 'package:database_service/src/util/database_schema_statement_factory.dart';
import 'package:database_service/src/util/string_util.dart';

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

  /// Builds an `ALTER TABLE ... ADD COLUMN REAL NOT NULL` statement with the provided [defaultValue].
  static String addRealColumnStatement({
    required String tableName,
    required String columnName,
    required double defaultValue,
  }) {
    return _addRealColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: false,
      defaultValue: defaultValue,
    );
  }

  /// Builds an `ALTER TABLE ... ADD COLUMN REAL` statement that allows `NULL` values.
  static String addRealNullableColumnStatement({
    required String tableName,
    required String columnName,
  }) {
    return _addRealColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: true,
    );
  }

  /// Builds an `ALTER TABLE ... ADD COLUMN TEXT NOT NULL` statement with the provided [defaultValue].
  static String addTextColumnStatement({
    required String tableName,
    required String columnName,
    required String defaultValue,
  }) {
    return _addTextColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: false,
      defaultValue: defaultValue,
    );
  }

  /// Builds an `ALTER TABLE ... ADD COLUMN TEXT` statement that allows `NULL` values.
  static String addTextNullableColumnStatement({
    required String tableName,
    required String columnName,
    String? defaultValue,
  }) {
    return _addTextColumn(
      tableName: tableName,
      columnName: columnName,
      isNullable: true,
      defaultValue: defaultValue,
    );
  }

  /// Builds an `ALTER TABLE ... RENAME COLUMN ... TO ...` statement.
  static String renameColumnStatement({
    required String tableName,
    required String oldColumnName,
    required String newColumnName,
  }) {
    return 'ALTER TABLE $tableName RENAME COLUMN $oldColumnName TO $newColumnName';
  }

  /// Builds a series of SQL statements to change the schema of a table.
  ///
  /// - Creates a temporary table with the new schema.
  /// - Inserts data from the old table into the temporary table.
  /// - Drops the old table.
  /// - Renames the temporary table to the old table name.
  /// - Optionally creates indexes for the new table.
  static List<String> changeTableSchemaStatements({
    required String tableName,
    required String Function(String tempTableName) createNewTableStatement,
    required List<String>? insertIntoColumns,
    required List<String>? selectColumns,
    List<String>? columnNamesForIndexes,
  }) {
    final List<String> statements = <String>[];

    final String tempTableName = '${tableName}_temp';

    final String createNewTableStatementForTempTable = createNewTableStatement.call(tempTableName);
    statements.add(createNewTableStatementForTempTable);

    statements.add(
      insertIntoTableStatement(
        insertIntoTableName: tempTableName,
        selectTableName: tableName,
        insertIntoColumns: insertIntoColumns,
        selectColumns: selectColumns,
      ),
    );

    statements.add(dropTableStatement(tableName));

    statements.add(renameTableStatement(oldTableName: tempTableName, newTableName: tableName));

    if (columnNamesForIndexes != null && columnNamesForIndexes.isNotEmpty) {
      statements.addAll(
        DatabaseSchemaStatementFactory.buildCreateIndexesIfNotExistsStatements(
          tableName: tableName,
          columnNames: columnNamesForIndexes,
        ),
      );
    }

    return statements;
  }

  /// Builds an `INSERT INTO ... SELECT ...` statement.
  static String insertIntoTableStatement({
    required String insertIntoTableName,
    required String selectTableName,
    required List<String>? insertIntoColumns,
    required List<String>? selectColumns,
  }) {
    final String formattedInsertIntoColumns = insertIntoColumns != null
        ? '(${insertIntoColumns.joinWithCommaAndSpace()})'
        : emptyString;
    final String formattedSelectColumns = selectColumns?.joinWithCommaAndSpace() ?? '*';
    return 'INSERT INTO $insertIntoTableName ($formattedInsertIntoColumns) SELECT $formattedSelectColumns FROM $selectTableName';
  }

  /// Builds an `ALTER TABLE ... RENAME TO ...` statement.
  static String renameTableStatement({
    required String oldTableName,
    required String newTableName,
  }) {
    return 'ALTER TABLE $oldTableName RENAME TO $newTableName';
  }

  /// Builds a `DROP TABLE ...` statement.
  static String dropTableStatement(String tableName) => 'DROP TABLE $tableName';

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

  static String _addRealColumn({
    required String tableName,
    required String columnName,
    required bool isNullable,
    double? defaultValue,
  }) {
    return addColumnStatement(
      tableName: tableName,
      columnName: columnName,
      type: 'REAL',
      isNullable: isNullable,
      defaultValue: defaultValue,
    );
  }

  static String _addTextColumn({
    required String tableName,
    required String columnName,
    required bool isNullable,
    String? defaultValue,
  }) {
    return addColumnStatement(
      tableName: tableName,
      columnName: columnName,
      type: 'TEXT',
      isNullable: isNullable,
      defaultValue: defaultValue,
    );
  }
}
