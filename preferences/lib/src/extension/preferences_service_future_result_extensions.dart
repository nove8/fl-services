import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:preferences_service/src/preferences_service.dart';

/// Extension providing convenience methods for [Future<Result<PreferencesService>>].
extension PreferencesServiceFutureResultExtensions on Future<Result<PreferencesService>> {
  /// Gets a boolean value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Future<Result<bool?>> getBoolean(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.getBoolean(key);
    });
  }

  /// Gets a string value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Future<Result<String?>> getString(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.getString(key);
    });
  }

  /// Gets an integer value from preferences.
  /// [key] is the name of the preference to retrieve.
  /// Returns null if the preference does not exist.
  Future<Result<int?>> getInt(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.getInt(key);
    });
  }

  /// Gets a double value from preferences.
  /// [key] is the name of the preference to retrieve.
  Future<Result<double?>> getDouble(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.getDouble(key);
    });
  }

  /// Gets a list of strings from preferences.
  /// [key] is the name of the preference to retrieve.
  /// [defaultValue] is the value to return if the preference does not exist.
  Future<Result<List<String>?>> getStringList(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.getStringList(key);
    });
  }

  /// Stores a boolean value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setBoolean(
    String key, {
    required bool value,
  }) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setBoolean(key, value: value);
    });
  }

  /// Stores a string value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setString(
    String key, {
    required String value,
  }) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setString(key, value: value);
    });
  }

  /// Stores an integer value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setInt(
    String key,
    int value,
  ) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setInt(key, value);
    });
  }

  /// Stores a double value in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setDouble(
    String key,
    double value,
  ) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setDouble(key, value);
    });
  }

  /// Stores a list of strings in preferences.
  /// [key] is the name of the preference to store.
  /// [value] is the value to store.
  Future<Result<void>> setStringList(
    String key,
    List<String> value,
  ) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setStringList(key, value);
    });
  }

  /// Removes a value from preference
  /// [key] is the name of the preference to remove.
  Future<Result<void>> remove(String key) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.remove(key);
    });
  }

  /// Clears all preferences storage.
  Future<Result<void>> clear() {
    return flatMapFuture((PreferencesService preferencesService) => preferencesService.clear());
  }
}
