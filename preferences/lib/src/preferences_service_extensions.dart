import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:preferences_service/preferences_service.dart';
import 'package:preferences_service/src/util/collection_util.dart';
import 'package:preferences_service/src/util/object_util.dart';

/// Extension providing convenience methods for [PreferencesService].
extension PreferencesServiceExtensions on PreferencesService {
  /// Gets a boolean value with default value of false.
  Result<bool> getBooleanOrFalse(String key) => getBoolean(key, defaultValue: false);

  /// Gets an integer value with default value of zero.
  Result<int> getIntOrZero(String key) => getInt(key, defaultValue: 0);

  /// Gets a string set from preferences.
  Result<Set<String>> getStringSet(String key) =>
      getStringList(key).map((List<String> list) => list.toUnmodifiableSet());

  /// Saves a [value] to Preferences.
  ///
  /// If [value] is null, this is equivalent to calling [remove(key)] on the [key].
  /// If [value] has unsupported type then nothing happened.
  Future<Result<void>> setValue(String key, Object? value) {
    return switch (value) {
      null => remove(key),
      List<String>() => setStringList(key, value),
      bool() => setBoolean(key, value: value),
      int() => setInt(key, value),
      double() => setDouble(key, value),
      String() => setString(key, value: value),
      _ => emptyResult.toFuture(),
    };
  }

  /// Saves a string set to preferences.
  Future<Result<void>> setStringSet(String key, Set<String> set) =>
      setStringList(key, set.toUnmodifiableList());
}
