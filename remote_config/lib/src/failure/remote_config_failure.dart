import 'package:common_result/common_result.dart';

/// A base class for any remote config failure.
sealed class RemoteConfigFailure implements Failure {}

/// Failure during remote config initialization.
final class RemoteConfigInitializationFailure implements RemoteConfigFailure {
  /// Creates a [RemoteConfigInitializationFailure].
  const RemoteConfigInitializationFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemoteConfigInitializationFailure{error: $_error}';
  }
}

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

/// Failure during fetching ad activating remote config.
final class FetchAndActivateRemoteConfigFailure implements RemoteConfigFailure {
  /// Creates a [FetchAndActivateRemoteConfigFailure].
  const FetchAndActivateRemoteConfigFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'FetchRemoteConfigSettingsFailure{error: $_error}';
  }
}

/// Failure for missing remote config parameter.
class MissingRemoteConfigParameterForKeyFailure implements RemoteConfigFailure {
  /// Creates a [MissingRemoteConfigParameterForKeyFailure].
  const MissingRemoteConfigParameterForKeyFailure({
    required this.parameterKey,
  });

  /// A key of the parameter.
  final String parameterKey;

  @override
  String toString() {
    return 'MissingRemoteConfigParameterForKeyFailure{parameterKey: $parameterKey}';
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
class MissingDefaultValueInLabelsSegmentedRemoteConfigParameterFailure
    implements RemoteConfigFailure {
  /// Default const constructor.
  const MissingDefaultValueInLabelsSegmentedRemoteConfigParameterFailure();
}
