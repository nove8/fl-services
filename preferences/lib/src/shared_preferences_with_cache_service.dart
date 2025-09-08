import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:preferences_service/src/failure/preferences_failure.dart';
import 'package:preferences_service/src/preferences_service.dart';
import 'package:preferences_service/src/util/async_util.dart';
import 'package:preferences_service/src/util/collection_util.dart';
import 'package:preferences_service/src/util/object_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides a persistent store for simple data. Cache provided to allow for synchronous gets.
///
/// [keyPrefix] is a string that will be added to all key to ensure the uniqueness of the keys.
/// [allKeys] is keys that will be fetched during `get` and `init` methods.
/// A `null` [allKeys] will prevent filtering, allowing all items to be cached.
/// An empty [allKeys] will prevent all caching as well as getting and setting.
/// Setting an [allKeys] is strongly recommended, to prevent getting and caching unneeded or unexpected data.
final class SharedPreferencesWithCacheService implements PreferencesService {
  /// Creates a [SharedPreferencesWithCacheService].
  const SharedPreferencesWithCacheService({
    required SharedPreferencesWithCache sharedPreferencesWithCache,
    required String keyPrefix,
  }) : _preferences = sharedPreferencesWithCache,
       _keyPrefix = keyPrefix;

  final SharedPreferencesWithCache _preferences;
  final String _keyPrefix;

  /// Creates a [SharedPreferencesWithCacheService] instance.
  static Future<Result<SharedPreferencesWithCacheService>> create({
    String keyPrefix = '',
    Set<String>? allKeys,
  }) {
    final SharedPreferencesWithCacheOptions cacheOptions = SharedPreferencesWithCacheOptions(
      allowList: allKeys
          ?.map((String key) => _getKeyPrefixWithKey(keyPrefix: keyPrefix, key: key))
          .toUnmodifiableSet(),
    );

    return SharedPreferencesWithCache.create(
      cacheOptions: cacheOptions,
    ).mapToResult(PreferencesCreationFailure.new).mapAsync((
      SharedPreferencesWithCache sharedPreferencesWithCache,
    ) {
      return SharedPreferencesWithCacheService(
        sharedPreferencesWithCache: sharedPreferencesWithCache,
        keyPrefix: keyPrefix,
      );
    });
  }

  static String _getKeyPrefixWithKey({
    required String keyPrefix,
    required String key,
  }) {
    return '$keyPrefix$key';
  }

  @override
  Result<bool?> getBoolean(String key) {
    return _getValue(
      key,
      valueProvider: _preferences.getBool,
    );
  }

  @override
  Result<String?> getString(String key) {
    return _getValue(
      key,
      valueProvider: _preferences.getString,
    );
  }

  @override
  Result<int?> getInt(String key) {
    return _getValue(
      key,
      valueProvider: _preferences.getInt,
    );
  }

  @override
  Result<double?> getDouble(String key) {
    return _getValue(
      key,
      valueProvider: _preferences.getDouble,
    );
  }

  @override
  Result<List<String>?> getStringList(String key) {
    return _getValue(
      key,
      valueProvider: _preferences.getStringList,
    );
  }

  @override
  Future<Result<void>> setBoolean(
    String key, {
    required bool value,
  }) {
    return _setValueIfChanged(
      key,
      value: value,
      valueResultProvider: getBoolean,
      setValueAction: _preferences.setBool,
    );
  }

  @override
  Future<Result<void>> setString(
    String key, {
    required String value,
  }) {
    return _setValueIfChanged(
      key,
      value: value,
      valueResultProvider: getString,
      setValueAction: _preferences.setString,
    );
  }

  @override
  Future<Result<void>> setInt(
    String key,
    int value,
  ) {
    return _setValueIfChanged(
      key,
      value: value,
      valueResultProvider: getInt,
      setValueAction: _preferences.setInt,
    );
  }

  @override
  Future<Result<void>> setDouble(
    String key,
    double value,
  ) {
    return _setValueIfChanged(
      key,
      value: value,
      valueResultProvider: getDouble,
      setValueAction: _preferences.setDouble,
    );
  }

  @override
  Future<Result<void>> setStringList(String key, List<String> value) {
    return _setValueIfChanged(
      key,
      value: value,
      valueResultProvider: getStringList,
      setValueAction: _preferences.setStringList,
    );
  }

  @override
  Future<Result<void>> remove(String key) {
    final String resultKey = _getPrefixedKey(key);
    return _preferences
        .remove(resultKey)
        .mapToResult((Object error) => RemovePreferenceFailure(error, key: resultKey));
  }

  @override
  Future<Result<void>> clear() {
    return _preferences.clear().mapToResult(ClearPreferencesFailure.new);
  }

  Result<T?> _getValue<T extends Object>(
    String key, {
    required T? Function(String resultKey) valueProvider,
  }) {
    final String resultKey = _getPrefixedKey(key);
    return mapToResult(
      valueProvider: () => valueProvider.call(resultKey),
      failureProvider: (Object error) => GetPreferenceFailure(error, key: resultKey),
    );
  }

  String _getPrefixedKey(String key) => _getKeyPrefixWithKey(keyPrefix: _keyPrefix, key: key);

  Future<Result<void>> _setValueIfChanged<T extends Object>(
    String key, {
    required T value,
    required Result<T?> Function(String key) valueResultProvider,
    required Future<void> Function(String resultKey, T value) setValueAction,
  }) {
    final T? currentValue = valueResultProvider.call(key).outputOrNull;
    final bool hasValueChanged = _hasValueChanged(currentValue: currentValue, newValue: value);

    if (hasValueChanged) {
      return _setValue(
        key,
        setAction: (String resultKey) => setValueAction(resultKey, value),
      );
    } else {
      return emptyResult.toFuture();
    }
  }

  bool _hasValueChanged<T>({required T? currentValue, required T newValue}) {
    final Equality<Object?> equality = currentValue is List && newValue is List
        ? const ListEquality<Object>()
        : const DefaultEquality<Object>();
    return !equality.equals(currentValue, newValue);
  }

  Future<Result<void>> _setValue(
    String key, {
    required Future<void> Function(String resultKey) setAction,
  }) {
    final String resultKey = _getPrefixedKey(key);
    return setAction
        .call(resultKey)
        .mapToResult((Object error) => SetPreferenceFailure(error, key: resultKey));
  }
}
