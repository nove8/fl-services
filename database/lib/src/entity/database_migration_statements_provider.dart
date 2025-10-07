/// Provides SQL migration statements for a specific database version.
abstract interface class DatabaseMigrationStatementsProvider {
  /// The target database version for this migration.
  int get databaseVersion;

  /// The SQL statements to execute for this migration.
  List<String> get migrationStatements;
}
