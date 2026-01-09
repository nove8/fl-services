import 'package:common_result/common_result.dart';

/// Base class for preferences failure
sealed class PreferencesFailure implements Failure {}

/// Failure during  preferences creation.
final class PreferencesCreationFailure implements PreferencesFailure {
  /// Creates a [PreferencesCreationFailure].
  const PreferencesCreationFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'PreferencesCreationFailure{_error: $_error}';
  }
}

/// Failure during getting preference.
final class GetPreferenceFailure implements PreferencesFailure {
  /// Creates a [GetPreferenceFailure].
  const GetPreferenceFailure(
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

/// Failure during saving preference.
final class SetPreferenceFailure implements PreferencesFailure {
  /// Creates a [SetPreferenceFailure].
  const SetPreferenceFailure(
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

/// Failure during checking if a preference exists.
final class CheckContainsPreferenceFailure implements PreferencesFailure {
  /// Creates a [CheckContainsPreferenceFailure].
  const CheckContainsPreferenceFailure(this._error, {required this.key});

  /// The preference key that failed to be checked.
  final String key;
  final Object _error;

  @override
  String toString() {
    return 'CheckContainsPreferenceFailure{key: $key, _error: $_error}';
  }
}

/// Failure during removing bool preference.
final class RemovePreferenceFailure implements PreferencesFailure {
  /// Creates a [SetPreferenceFailure].
  const RemovePreferenceFailure(
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
final class ClearPreferencesFailure implements PreferencesFailure {
  /// Creates a [SetPreferenceFailure].
  const ClearPreferencesFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'RemovePreferencesFailure{_error: $_error}';
  }
}

/// Failure during reloading preferences.
final class ReloadPreferencesFailure implements PreferencesFailure {
  /// Creates a [ReloadPreferencesFailure].
  const ReloadPreferencesFailure(this._error);

  final Object _error;

  @override
  String toString() {
    return 'ReloadPreferencesFailure{_error: $_error}';
  }
}
