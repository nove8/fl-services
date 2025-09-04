import 'package:async/async.dart';

/// A service interface for managing persistent preferences storage.
abstract interface class PreferencesService {
  /// Gets a boolean value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<bool> getBoolean(
    String key, {
    required bool defaultValue,
  });

  /// Gets an optional boolean value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<bool?> optBoolean(String key);

  /// Gets a string value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<String> getString(
    String key, {
    required String defaultValue,
  });

  /// Gets an optional string value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<String?> optString(String key);

  /// Gets an integer value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<int> getInt(
    String key, {
    required int defaultValue,
  });

  /// Gets an optional integer value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Result<int?> optInt(String key);

  /// Gets a double value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<double> getDouble(
    String key, {
    required double defaultValue,
  });

  /// Gets a list of strings from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Result<List<String>> getStringList(
    String key, {
    List<String> defaultValue = const <String>[],
  });

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
}
