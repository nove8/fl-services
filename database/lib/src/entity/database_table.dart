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

/// A database table that includes multiple index definitions.
abstract base class DatabaseTableWithIndexes extends DatabaseTable {
  /// Creates a [DatabaseTableWithIndexes].
  const DatabaseTableWithIndexes();

  @override
  List<String> get schemaList {
    return <String>[
      ...super.schemaList,
      ...buildCreateIndexStatements(),
    ];
  }

  /// Builds the CREATE INDEX SQL statements for this table.
  List<String> buildCreateIndexStatements();
}
