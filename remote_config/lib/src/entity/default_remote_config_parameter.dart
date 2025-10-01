import 'dart:convert';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_config_service/src/failure/remote_config_failure.dart';
import 'package:remote_config_service/src/util/object_util.dart';

/// A function that provides a remote config value for a given [parameterKey].
typedef RemoteConfigValueProvider =
    Future<Result<RemoteConfigValue>> Function({required String parameterKey});

/// A base class for default remote config parameter.
final class DefaultRemoteConfigParameter {
  /// Creates a [DefaultRemoteConfigParameter].
  const DefaultRemoteConfigParameter({
    required String parameterKey,
    required RemoteConfigValueProvider remoteConfigValueProvider,
  }) : _parameterKey = parameterKey,
       _remoteConfigValueProvider = remoteConfigValueProvider;

  final String _parameterKey;
  final RemoteConfigValueProvider _remoteConfigValueProvider;

  /// Gets [T] parameter value.
  /// Supported types are: String, int, double, bool.
  Future<Result<T>> getValue<T extends Object>() {
    return _remoteConfigValueProvider.call(parameterKey: _parameterKey).flatMapAsync((
      RemoteConfigValue remoteConfigValue,
    ) {
      return switch (remoteConfigValue.source) {
        ValueSource.valueStatic => MissingRemoteConfigParameterForKeyFailure(
          parameterKey: _parameterKey,
        ).toFailureResult(),
        ValueSource.valueDefault || ValueSource.valueRemote => _decodeRemoteConfigValue(remoteConfigValue),
      };
    });
  }

  /// Gets parameter value as collection of [T] values.
  /// Supported collection types are: List, Set.
  Future<Result<CollectionT>> getCollectionValue<T, CollectionT extends Iterable<T>>() {
    return _getJsonValue<Iterable<Object?>>().flatMapAsync((Iterable<Object?> collection) {
      return decodeCollectionValue<T, CollectionT>(collection);
    });
  }

  /// Gets parameter value as `Map<String, Object?>`.
  Future<Result<Map<String, Object?>>> getJsonMapValue() => _getJsonValue();

  /// Decodes value from [valueProvider].
  Result<T> decodeValue<T>(T Function() valueProvider) {
    return mapToResult(
      valueProvider: valueProvider,
      failureProvider: RemoteConfigParameterValueDecodingFailure.new,
    );
  }

  /// Decodes [collection] value.
  Result<CollectionT> decodeCollectionValue<T, CollectionT extends Iterable<T>>(
    Iterable<Object?> collection,
  ) {
    return _decodeCollectionValues<T>(collection)
        .map((Iterable<T> mappedIterable) => _obtainCollection<T, CollectionT>(mappedIterable))
        .flatMapNullValueToFailure(() => const UnsupportedParameterValueCollectionTypeFailure());
  }

  Result<T> _decodeRemoteConfigValue<T extends Object>(RemoteConfigValue configValue) {
    return decodeValue(() {
      if (T == String) {
        return configValue.asString() as T;
      } else if (T == int) {
        return configValue.asInt() as T;
      } else if (T == double) {
        return configValue.asDouble() as T;
      } else if (T == bool) {
        return configValue.asBool() as T;
      } else {
        return null;
      }
    }).flatMapNullValueToFailure(() => const UnsupportedRemoteConfigParameterValueTypeFailure());
  }

  Future<Result<JsonT>> _getJsonValue<JsonT extends Object>() {
    return getValue<String>().flatMapAsync((String jsonString) {
      return mapToResult(
        valueProvider: () => jsonDecode(jsonString) as JsonT,
        failureProvider: RemoteConfigJsonParameterValueDecodingFailure.new,
      );
    });
  }

  Result<Iterable<T>> _decodeCollectionValues<T>(Iterable<Object?> iterable) {
    return mapToResult(
      valueProvider: () => iterable.map((Object? element) => element as T),
      failureProvider: RemoteConfigIterableParameterValueDecodingFailure.new,
    );
  }

  CollectionT? _obtainCollection<T, CollectionT extends Iterable<T>>(
    Iterable<T> iterable,
  ) {
    if (CollectionT == List<T>) {
      return List<T>.unmodifiable(iterable) as CollectionT;
    } else if (CollectionT == Set<T>) {
      return Set<T>.unmodifiable(iterable) as CollectionT;
    } else {
      return null;
    }
  }
}
