import 'package:common_result/common_result.dart';

/// A base class for any remote config failure.
sealed class RemoteConfigFailure implements Failure {}

/// Failure during setting remote config settings.
final class SetRemoteConfigSettingsFailure implements RemoteConfigFailure {
  /// Creates a [SetRemoteConfigSettingsFailure].
  const SetRemoteConfigSettingsFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'SetRemoteConfigSettingsFailure{error: $_error}';
  }
}

/// Failure during fetching remote config.
final class FetchRemoteConfigFailure implements RemoteConfigFailure {
  /// Creates a [FetchRemoteConfigFailure].
  const FetchRemoteConfigFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'FetchRemoteConfigFailure{error: $_error}';
  }
}

/// Failure during ensuring remote config is initialized.
final class EnsureRemoteConfigInitializedFailure implements RemoteConfigFailure {
  /// Creates a [EnsureRemoteConfigInitializedFailure].
  const EnsureRemoteConfigInitializedFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'EnsureRemoteConfigInitializedFailure{error: $_error}';
  }
}

/// Failure during activating remote config.
final class ActivateRemoteConfigFailure implements RemoteConfigFailure {
  /// Creates a [ActivateRemoteConfigFailure].
  const ActivateRemoteConfigFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'ActivateRemoteConfigFailure{error: $_error}';
  }
}

/// Failure during decoding remote config parameter value.
class RemoteConfigParameterValueDecodingFailure implements RemoteConfigFailure {
  /// Creates a [RemoteConfigParameterValueDecodingFailure].
  const RemoteConfigParameterValueDecodingFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemoteConfigParameterValueDecodingFailure{error: $_error}';
  }
}

/// Failure for unsupported remote config parameter value type.
class UnsupportedRemoteConfigParameterValueTypeFailure implements RemoteConfigFailure {
  /// Default const constructor.
  const UnsupportedRemoteConfigParameterValueTypeFailure();
}

/// Failure for unsupported parameter value collection type.
class UnsupportedParameterValueCollectionTypeFailure implements RemoteConfigFailure {
  /// Default const constructor.
  const UnsupportedParameterValueCollectionTypeFailure();
}

/// Failure during decoding remote config json parameter value.
class RemoteConfigJsonParameterValueDecodingFailure implements RemoteConfigFailure {
  /// Creates a [RemoteConfigJsonParameterValueDecodingFailure].
  const RemoteConfigJsonParameterValueDecodingFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemoteConfigJsonParameterValueDecodingFailure{error: $_error}';
  }
}

/// Failure during decoding remote config iterable parameter value.
class RemoteConfigIterableParameterValueDecodingFailure implements RemoteConfigFailure {
  /// Creates a [RemoteConfigIterableParameterValueDecodingFailure].
  const RemoteConfigIterableParameterValueDecodingFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemoteConfigIterableParameterValueDecodingFailure{error: $_error}';
  }
}

/// Failure during parsing remote config feature parameter.
class RemoteConfigFeatureParameterParsingFailure implements RemoteConfigFailure {
  /// Creates a [RemoteConfigFeatureParameterParsingFailure].
  const RemoteConfigFeatureParameterParsingFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemoteConfigFeatureParameterParsingFailure{error: $_error}';
  }
}

/// Failure for missing default value in labels segmented remote config parameter.
class MissingDefaultValueInLabelsSegmentedRemoteConfigParameterFailure implements RemoteConfigFailure {
  /// Default const constructor.
  const MissingDefaultValueInLabelsSegmentedRemoteConfigParameterFailure();
}
