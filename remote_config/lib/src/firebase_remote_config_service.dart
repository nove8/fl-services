import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_config_service/src/entity/default_remote_config_parameter.dart';
import 'package:remote_config_service/src/entity/labels_segmented_remote_config_parameter.dart';
import 'package:remote_config_service/src/failure/remote_config_failure.dart';
import 'package:remote_config_service/src/remote_config_service.dart';
import 'package:remote_config_service/src/util/async_util.dart';

/// The entry point for accessing remote config.
final class FirebaseRemoteConfigService implements RemoteConfigService {
  /// Creates a [FirebaseRemoteConfigService].
  FirebaseRemoteConfigService({
    required bool isTestEnvironment,
    Duration fetchTimeout = _defaultFetchTimeout,
  }) : _isTestEnvironment = isTestEnvironment,
       _fetchTimeout = fetchTimeout {
    _init();
  }

  static const Duration _defaultFetchTimeout = Duration(seconds: 10);

  static const Duration _testEnvironmentMinimumFetchInterval = Duration.zero;
  static const Duration _prodEnvironmentMinimumFetchInterval = Duration(minutes: 5);

  final bool _isTestEnvironment;
  final Duration _fetchTimeout;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  final Completer<Result<void>> _configInitializationCompleter = Completer<Result<void>>();

  /// Fires when config was fully initialized.
  Future<Result<void>> get _configInitialization => _configInitializationCompleter.future;

  /// Awaits config initialization and gets [String] parameter value for selected [parameterKey].
  @override
  Future<Result<String>> getStringParameterValue({required String parameterKey}) =>
      _getDefaultParameterValue(parameterKey: parameterKey);

  /// Awaits config initialization and gets [int] parameter value for selected [parameterKey].
  @override
  Future<Result<int>> getIntParameterValue({required String parameterKey}) =>
      _getDefaultParameterValue(parameterKey: parameterKey);

  /// Awaits config initialization and gets [double] parameter value for selected [parameterKey].
  @override
  Future<Result<double>> getDoubleParameterValue({required String parameterKey}) =>
      _getDefaultParameterValue(parameterKey: parameterKey);

  /// Awaits config initialization and gets [bool] parameter value for selected [parameterKey].
  @override
  Future<Result<bool>> getBoolParameterValue({required String parameterKey}) =>
      _getDefaultParameterValue(parameterKey: parameterKey);

  /// Awaits config initialization and gets parameter value as List of [T] values
  /// for selected [parameterKey].
  @override
  Future<Result<List<T>>> getListParameterValue<T>({required String parameterKey}) {
    return _getCollectionDefaultParameterValue<T, List<T>>(parameterKey: parameterKey);
  }

  /// Awaits config initialization and gets parameter value as Set of [T] values
  /// for selected [parameterKey].
  @override
  Future<Result<Set<T>>> getSetParameterValue<T>({required String parameterKey}) {
    return _getCollectionDefaultParameterValue<T, Set<T>>(parameterKey: parameterKey);
  }

  /// Awaits config initialization and gets complex feature parameter value for selected [parameterKey].
  /// On any thrown error from [featureFactory] will be returned [RemoteConfigFeatureParameterParsingFailure].
  @override
  Future<Result<FeatureT>> getFeatureParameterValue<FeatureT extends Object>({
    required String parameterKey,
    required FeatureT Function(Map<String, Object?> json) featureFactory,
  }) {
    return _getParameterValueWithDefaultRemoteConfigParameter(
      parameterKey: parameterKey,
      parameterValueProvider: (DefaultRemoteConfigParameter parameter) {
        return parameter.getJsonMapValue().flatMapAsync((Map<String, Object?> jsonMap) {
          try {
            return featureFactory.call(jsonMap).toSuccessResult();
          } catch (error) {
            return FailureResult(RemoteConfigFeatureParameterParsingFailure(error));
          }
        });
      },
    );
  }

  /// Awaits config initialization and gets [String] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<String>> getStringLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getLabelsSegmentedParameterValue(parameterKey: parameterKey, userLabels: userLabels);
  }

  /// Awaits config initialization and gets [int] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<int>> getIntLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getLabelsSegmentedParameterValue(parameterKey: parameterKey, userLabels: userLabels);
  }

  /// Awaits config initialization and gets [double] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<double>> getDoubleLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getLabelsSegmentedParameterValue(parameterKey: parameterKey, userLabels: userLabels);
  }

  /// Awaits config initialization and gets [bool] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<bool>> getBoolLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getLabelsSegmentedParameterValue(parameterKey: parameterKey, userLabels: userLabels);
  }

  /// Awaits config initialization and gets parameter value as List of [T] values
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<List<T>>> getListLabelsSegmentedParameterValue<T>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getCollectionLabelsSegmentedParameterValue<T, List<T>>(
      parameterKey: parameterKey,
      userLabels: userLabels,
    );
  }

  /// Awaits config initialization and gets parameter value as Set of [T] values
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  @override
  Future<Result<Set<T>>> getSetLabelsSegmentedParameterValue<T>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getCollectionLabelsSegmentedParameterValue<T, Set<T>>(
      parameterKey: parameterKey,
      userLabels: userLabels,
    );
  }

  Future<void> _init() async {
    await _setConfigSettings();
    await _fetchAndActivateConfig().onComplete(_configInitializationCompleter.complete);
  }

  Future<Result<void>> _setConfigSettings() {
    final Duration minimumFetchInterval = _isTestEnvironment
        ? _testEnvironmentMinimumFetchInterval
        : _prodEnvironmentMinimumFetchInterval;
    return _remoteConfig
        .setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: _fetchTimeout,
            minimumFetchInterval: minimumFetchInterval,
          ),
        )
        .mapToResult(SetRemoteConfigSettingsFailure.new);
  }

  Future<Result<void>> _fetchAndActivateConfig() {
    return _remoteConfig.fetchAndActivate().mapToResult(FetchAndActivateRemoteConfigFailure.new);
  }

  Future<Result<T>> _getDefaultParameterValue<T extends Object>({required String parameterKey}) {
    return _getParameterValueWithDefaultRemoteConfigParameter(
      parameterKey: parameterKey,
      parameterValueProvider: (DefaultRemoteConfigParameter parameter) => parameter.getValue(),
    );
  }

  Future<Result<T>> _getParameterValueWithDefaultRemoteConfigParameter<T>({
    required String parameterKey,
    required Future<Result<T>> Function(DefaultRemoteConfigParameter parameter) parameterValueProvider,
  }) {
    final DefaultRemoteConfigParameter parameter = DefaultRemoteConfigParameter(
      parameterKey: parameterKey,
      remoteConfigValueProvider: _provideRemoteConfigValue,
    );
    return parameterValueProvider.call(parameter);
  }

  Future<Result<RemoteConfigValue>> _provideRemoteConfigValue({required String parameterKey}) {
    return _configInitialization.mapAsync((_) => _remoteConfig.getValue(parameterKey));
  }

  Future<Result<CollectionT>> _getCollectionDefaultParameterValue<T, CollectionT extends Iterable<T>>({
    required String parameterKey,
  }) {
    return _getParameterValueWithDefaultRemoteConfigParameter(
      parameterKey: parameterKey,
      parameterValueProvider: (DefaultRemoteConfigParameter parameter) =>
          parameter.getCollectionValue<T, CollectionT>(),
    );
  }

  Future<Result<T>> _getLabelsSegmentedParameterValue<T extends Object>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  }) {
    return _getValueWithLabelsSegmentedRemoteConfigParameter(
      parameterKey: parameterKey,
      userLabels: userLabels,
      parameterValueProvider: (LabelsSegmentedRemoteConfigParameter parameter) => parameter.getValue(),
    );
  }

  Future<Result<T>> _getValueWithLabelsSegmentedRemoteConfigParameter<T>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
    required Future<Result<T>> Function(LabelsSegmentedRemoteConfigParameter parameter)
    parameterValueProvider,
  }) {
    final LabelsSegmentedRemoteConfigParameter parameter = LabelsSegmentedRemoteConfigParameter(
      parameterKey: parameterKey,
      remoteConfigValueProvider: _provideRemoteConfigValue,
      userLabels: userLabels,
    );
    return parameterValueProvider.call(parameter);
  }

  Future<Result<CollectionT>> _getCollectionLabelsSegmentedParameterValue<
    T,
    CollectionT extends Iterable<T>
  >({required String parameterKey, required FutureOr<Map<String, String>> userLabels}) {
    return _getValueWithLabelsSegmentedRemoteConfigParameter(
      parameterKey: parameterKey,
      userLabels: userLabels,
      parameterValueProvider: (LabelsSegmentedRemoteConfigParameter parameter) =>
          parameter.getCollectionValue<T, CollectionT>(),
    );
  }
}
