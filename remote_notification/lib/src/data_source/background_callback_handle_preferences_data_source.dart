import 'dart:ui';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:preferences_service/shared_preferences_service_with_cache.dart' as preferences_service;
import 'package:remote_notification_service/src/util/object_util.dart';

/// Data source for storing and retrieving the [CallbackHandle] used for background remote notifications.
abstract final class BackgroundCallbackHandlePreferencesDataSource {
  static const String _preferencesPrefix = 'remote_notification_service';
  static const String _backgroundCallbackHandleKey = 'background_callback_handle_key';

  /// Retrieves the stored [CallbackHandle] for background remote notification, if present.
  static Future<Result<CallbackHandle?>> getBackgroundCallbackHandle() {
    return _obtainPreferences().flatMapAsync((
      preferences_service.SharedPreferencesWithCacheService preferencesService,
    ) {
      return preferencesService.getInt(_backgroundCallbackHandleKey).map((int? rawCallbackHandle) {
        return rawCallbackHandle?.let(CallbackHandle.fromRawHandle);
      });
    });
  }

  /// Stores the given [CallbackHandle] for use in background remote notification handling.
  static Future<Result<void>> setBackgroundCallbackHandle(CallbackHandle handle) {
    return _obtainPreferences().mapFuture((
      preferences_service.SharedPreferencesWithCacheService preferencesService,
    ) {
      return preferencesService.setInt(_backgroundCallbackHandleKey, handle.toRawHandle());
    });
  }

  static Future<Result<preferences_service.SharedPreferencesWithCacheService>> _obtainPreferences() {
    return preferences_service.SharedPreferencesWithCacheService.create(keyPrefix: _preferencesPrefix);
  }
}
