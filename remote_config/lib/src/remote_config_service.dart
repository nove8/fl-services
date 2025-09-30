import 'dart:async';

import 'package:async/async.dart';
import 'package:remote_config_service/src/failure/remote_config_failure.dart';

/// An interface for a service that provides remote configuration parameters.
abstract interface class RemoteConfigService {
  /// Awaits config initialization and gets [String] parameter value for selected [parameterKey].
  Future<Result<String>> getStringParameterValue({required String parameterKey});

  /// Awaits config initialization and gets [int] parameter value for selected [parameterKey].
  Future<Result<int>> getIntParameterValue({required String parameterKey});

  /// Awaits config initialization and gets [double] parameter value for selected [parameterKey].
  Future<Result<double>> getDoubleParameterValue({required String parameterKey});

  /// Awaits config initialization and gets [bool] parameter value for selected [parameterKey].
  Future<Result<bool>> getBoolParameterValue({required String parameterKey});

  /// Awaits config initialization and gets parameter value as List of [T] values
  /// for selected [parameterKey].
  Future<Result<List<T>>> getListParameterValue<T>({required String parameterKey});

  /// Awaits config initialization and gets parameter value as Set of [T] values
  /// for selected [parameterKey].
  Future<Result<Set<T>>> getSetParameterValue<T>({required String parameterKey});

  /// Awaits config initialization and gets complex feature parameter value for selected [parameterKey].
  /// On any thrown error from [featureFactory] will be returned [RemoteConfigFeatureParameterParsingFailure].
  Future<Result<FeatureT>> getFeatureParameterValue<FeatureT extends Object>({
    required String parameterKey,
    required FeatureT Function(Map<String, Object?> json) featureFactory,
  });

  /// Awaits config initialization and gets [String] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<String>> getStringLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });

  /// Awaits config initialization and gets [int] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<int>> getIntLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });

  /// Awaits config initialization and gets [double] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<double>> getDoubleLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });

  /// Awaits config initialization and gets [bool] labels segmented parameter value
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<bool>> getBoolLabelsSegmentedParameterValue({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });

  /// Awaits config initialization and gets parameter value as List of [T] values
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<List<T>>> getListLabelsSegmentedParameterValue<T>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });

  /// Awaits config initialization and gets parameter value as Set of [T] values
  /// for selected [parameterKey].
  /// [userLabels] is a map of user labels where key is the label key and value is the label value.
  Future<Result<Set<T>>> getSetLabelsSegmentedParameterValue<T>({
    required String parameterKey,
    required FutureOr<Map<String, String>> userLabels,
  });
}
