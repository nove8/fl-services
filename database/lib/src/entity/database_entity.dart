/// A base interface for entities that can be stored in a database.
abstract interface class DatabaseEntity {
  /// The name of the database table this entity belongs to.
  String get tableName;

  /// Converts this entity to a map representation for database storage.
  Map<String, Object?> toMap();
}

/// A database entity that has a unique identifier.
abstract interface class IdentifiableDatabaseEntity implements DatabaseEntity {
  /// The unique identifier for this entity.
  String get id;
}
