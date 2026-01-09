import 'package:async/async.dart';

/// A service interface for managing persistent preferences storage.
abstract interface class PreferencesService {
  /// Gets a boolean value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<bool?> getBoolean(String key);

  /// Gets a string value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<String?> getString(String key);

  /// Gets an integer value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<int?> getInt(String key);

  /// Gets a double value from preferences.
  /// [key] is the name of the preference to retrieve.
  Result<double?> getDouble(String key);

  /// Gets a list of strings from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<List<String>?> getStringList(String key);

  /// Stores a boolean value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setBoolean(
    String key, {
    required bool value,
  });

  /// Stores a string value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setString(
    String key, {
    required String value,
  });

  /// Stores an integer value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setInt(
    String key,
    int value,
  );

  /// Stores a double value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setDouble(
    String key,
    double value,
  );

  /// Stores a list of strings in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setStringList(
    String key,
    List<String> value,
  );

  /// Removes a value from preference
  /// [key] is the name of the preference to remove.
  Future<Result<void>> remove(String key);

  /// Clears preferences storage.
  Future<Result<void>> clear();

  /// Reloads preferences storage.
  Future<Result<void>> reload();
}
