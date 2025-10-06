/// Provides SQL migration statements for a specific database version.
abstract base class DatabaseMigrationStatementsProvider {
  /// Creates a [DatabaseMigrationStatementsProvider].
  const DatabaseMigrationStatementsProvider({
    required this.databaseVersion,
    required this.migrationStatements,
  });

  /// The target database version for this migration.
  final int databaseVersion;

  /// The SQL statements to execute for this migration.
  final List<String> migrationStatements;
}
