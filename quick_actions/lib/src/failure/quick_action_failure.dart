import 'package:common_result/common_result.dart';

/// Base class for quick action failures.
sealed class QuickActionFailure implements Failure {}

/// Failure that occurs when setting the application's quick action items fails.
final class SetQuickActionsFailure implements QuickActionFailure {
  /// Creates a [SetQuickActionsFailure].
  const SetQuickActionsFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'SetQuickActionsFailure{error: $error}';
  }
}
