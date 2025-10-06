/// Base class for database table schema definitions.
abstract base class DatabaseTable {
  /// Creates a [DatabaseTable].
  const DatabaseTable();

  /// Returns the SQL statements needed to create this table.
  List<String> get schemaList => <String>[buildCreateTableStatement()];

  /// Builds the CREATE TABLE SQL statement for this table.
  String buildCreateTableStatement();
}

/// A database table that includes an index definition.
abstract base class DatabaseTableWithIndex extends DatabaseTable {
  /// Creates a [DatabaseTableWithIndex].
  const DatabaseTableWithIndex();

  @override
  List<String> get schemaList {
    return <String>[
      ...super.schemaList,
      buildCreateIndexStatement(),
    ];
  }

  /// Builds the CREATE INDEX SQL statement for this table.
  String buildCreateIndexStatement();
}
