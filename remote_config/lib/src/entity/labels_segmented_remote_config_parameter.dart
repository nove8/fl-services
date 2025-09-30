import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:meta/meta.dart';
import 'package:remote_config_service/src/entity/default_remote_config_parameter.dart';
import 'package:remote_config_service/src/failure/remote_config_failure.dart';
import 'package:remote_config_service/src/util/async_util.dart';
import 'package:remote_config_service/src/util/collection_util.dart';

/// A remote config parameter with labels segmentation logic.
final class LabelsSegmentedRemoteConfigParameter {
  /// Creates a [LabelsSegmentedRemoteConfigParameter].
  LabelsSegmentedRemoteConfigParameter({
    required String parameterKey,
    required RemoteConfigValueProvider remoteConfigValueProvider,
    required FutureOr<Map<String, String>> userLabels,
  }) : _defaultRemoteConfigParameter = DefaultRemoteConfigParameter(
         parameterKey: parameterKey,
         remoteConfigValueProvider: remoteConfigValueProvider,
       ),
       _userLabels = userLabels;

  static const String _defaultValueKey = 'default';

  final DefaultRemoteConfigParameter _defaultRemoteConfigParameter;
  final FutureOr<Map<String, String>> _userLabels;

  /// Gets [T] parameter value.
  /// Supported types are: String, int, double, bool.
  Future<Result<T>> getValue<T extends Object>() {
    return _defaultRemoteConfigParameter.getJsonMapValue().flatMapFuture((Map<String, Object?> jsonMap) {
      return getSegmentedValueFromJson(
        jsonMap,
        valueTransform: (Object? value) => _defaultRemoteConfigParameter.decodeValue(() => value! as T),
      );
    });
  }

  /// Gets parameter value as collection of [T] values.
  /// Supported collection types are: List, Set.
  Future<Result<CollectionT>> getCollectionValue<T, CollectionT extends Iterable<T>>() {
    return getValue<Iterable<Object?>>().flatMapAsync((Iterable<Object?> collection) {
      return _defaultRemoteConfigParameter.decodeCollectionValue<T, CollectionT>(collection);
    });
  }

  /// Gets a segmented value from [valueJson].
  @visibleForTesting
  Future<Result<T>> getSegmentedValueFromJson<T>(
    Map<String, Object?> valueJson, {
    required Result<T> Function(Object? field) valueTransform,
  }) async {
    final Map<String, String> userLabels = await _userLabels.wait();
    final Object? customValue = userLabels.isNotEmpty
        ? _findCustomValueForUserLabels(valueJson, userLabels)
        : null;

    if (customValue != null) {
      return valueTransform(customValue);
    } else {
      return valueJson.containsKey(_defaultValueKey)
          ? valueTransform(valueJson[_defaultValueKey])
          : const MissingDefaultValueInLabelsSegmentedRemoteConfigParameterFailure().toFailureResult();
    }
  }

  Object? _findCustomValueForUserLabels(
    Map<String, Object?> valueJson,
    Map<String, String> userLabels,
  ) {
    int maxMatches = 0;
    Object? resultValue;
    valueJson.forEach((String key, Object? value) {
      final Set<({String key, String value})> parsedLabels = _parseLabels(key);
      final int matchesCount = _calculateLabelsMatchesCount(
        userLabels: userLabels,
        parsedLabels: parsedLabels,
      );
      // We search for a value where ALL parsed labels match user's labels
      // with the highest number of overall matches
      if (matchesCount > maxMatches && matchesCount == parsedLabels.length) {
        resultValue = value;
        maxMatches = matchesCount;
      }
    });
    return resultValue;
  }

  Set<({String key, String value})> _parseLabels(String labelsData) {
    const String labelsSeparator = ',';
    const String labelComponentsSeparator = ':';

    final List<String> labels = labelsData.split(labelsSeparator);
    return labels.mapNotNullToList((String label) {
      final List<String> labelComponents = label.split(labelComponentsSeparator);
      return labelComponents.length == 2 ? (key: labelComponents.first, value: labelComponents.second) : null;
    }).toUnmodifiableSet();
  }

  int _calculateLabelsMatchesCount({
    required Map<String, String> userLabels,
    required Set<({String key, String value})> parsedLabels,
  }) {
    return parsedLabels.count((({String key, String value}) parsedLabel) {
      final String? userValue = userLabels[parsedLabel.key];
      return userValue == parsedLabel.value;
    });
  }
}
