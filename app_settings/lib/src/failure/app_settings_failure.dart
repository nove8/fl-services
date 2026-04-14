import 'package:common_result/common_result.dart';

/// Base class for app settings failures.
sealed class AppSettingsFailure implements Failure {}

/// Failure that occurs when opening app settings.
final class AppSettingsOpenFailure implements AppSettingsFailure {
  /// Creates an [AppSettingsOpenFailure].
  const AppSettingsOpenFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'AppSettingsOpenFailure{error: $error}';
  }
}
