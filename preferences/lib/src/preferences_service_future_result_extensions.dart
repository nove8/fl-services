import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:preferences_service/preferences_service.dart';

/// Extension providing convenience methods for [Future<Result<PreferencesService>>].
extension PreferencesServiceFutureResultExtensions on Future<Result<PreferencesService>> {
  /// Gets an optional boolean value from preferences.
  Future<Result<bool?>> optBoolean(String key) {
    return flatMapAsync((PreferencesService preferencesService) {
      return preferencesService.optBoolean(key);
    });
  }

  /// Stores a boolean value in preferences.
  Future<Result<void>> setBoolean(
    String key, {
    required bool value,
  }) {
    return flatMapFuture((PreferencesService preferencesService) {
      return preferencesService.setBoolean(key, value: value);
    });
  }

  /// Clears all preferences storage.
  Future<Result<void>> clear() {
    return flatMapFuture((PreferencesService preferencesService) => preferencesService.clear());
  }
}
