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

  static String _buildCreateIndexStatement({
    required String tableName,
    required String columnName,
    required bool isNeedToAddIfNotExists,
  }) {
    final StringBuffer statementBuffer = StringBuffer('CREATE INDEX');
    if (isNeedToAddIfNotExists) {
      statementBuffer.write(' IF NOT EXISTS');
    }
    final String indexName = '${tableName}_${columnName}_index';
    statementBuffer.write(' $indexName ON $tableName ($columnName)');
    return statementBuffer.toString();
  }
}
