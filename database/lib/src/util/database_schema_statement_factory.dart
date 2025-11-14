/// Factory for building database schema SQL statements.
abstract final class DatabaseSchemaStatementFactory {
  /// Builds a CREATE INDEX IF NOT EXISTS statement for the specified table and column.
  static String buildCreateIndexIfNotExistsStatement({
    required String tableName,
    required String columnName,
  }) {
    return _buildCreateIndexStatement(
      tableName: tableName,
      columnName: columnName,
      isNeedToAddIfNotExists: true,
    );
  }

  /// Builds a DROP INDEX IF EXISTS statement for the specified table and column.
  static String buildDropIndexIfExistsStatement({
    required String tableName,
    required String columnName,
  }) {
    final String indexName = _obtainIndexName(tableName: tableName, columnName: columnName);
    return 'DROP INDEX IF EXISTS $indexName';
  }

  static String _buildCreateIndexStatement({
    required String tableName,
    required String columnName,
    required bool isNeedToAddIfNotExists,
  }) {
    final StringBuffer statementBuffer = StringBuffer('CREATE INDEX');
    if (isNeedToAddIfNotExists) {
      statementBuffer.write(' IF NOT EXISTS');
    }
    final String indexName = _obtainIndexName(tableName: tableName, columnName: columnName);
    statementBuffer.write(' $indexName ON $tableName ($columnName)');
    return statementBuffer.toString();
  }

  static String _obtainIndexName({
    required String tableName,
    required String columnName,
  }) {
    return '${tableName}_${columnName}_index';
  }
}
