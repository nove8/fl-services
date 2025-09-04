import 'package:common_result/common_result.dart';

/// Base class for preferences failure
sealed class PreferencesFailure implements Failure {}

/// Failure during  preferences creation.
class PreferencesCreationFailure implements PreferencesFailure {
  /// Creates a [PreferencesCreationFailure].
  const PreferencesCreationFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'PreferencesCreationFailure{_error: $_error}';
  }
}

/// Failure during getting preferences.
class GetPreferencesFailure implements PreferencesFailure {
  /// Creates a [GetPreferencesFailure].
  const GetPreferencesFailure(
    this._error, {
    required this.key,
  });

  /// The preference key that failed to be retrieved.
  final String key;
  final Object _error;

  @override
  String toString() {
    return 'GetPreferencesFailure{key: $key, _error: $_error}';
  }
}

/// Failure during saving preferences.
class SetPreferencesFailure implements PreferencesFailure {
  /// Creates a [SetPreferencesFailure].
  const SetPreferencesFailure(
    this._error, {
    required this.key,
  });

  /// The preference key that failed to be saved.
  final String key;
  final Object _error;

  @override
  String toString() {
    return 'SetPreferencesFailure{key: $key, _error: $_error}';
  }
}

/// Failure during removing bool preferences.
class RemovePreferencesFailure implements PreferencesFailure {
  /// Creates a [SetPreferencesFailure].
  const RemovePreferencesFailure(
    this._error, {
    required this.key,
  });

  /// The preference key that failed to be removed.
  final String key;
  final Object _error;

  @override
  String toString() {
    return 'RemovePreferencesFailure{key: $key, _error: $_error}';
  }
}

/// Failure during clearing  preferences.
class ClearPreferencesFailure implements PreferencesFailure {
  /// Creates a [SetPreferencesFailure].
  const ClearPreferencesFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemovePreferencesFailure{_error: $_error}';
  }
}
