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

/// Failure when native reports a quick action id string that does not match any supported enum value.
final class UnknownQuickActionTypeFailure implements QuickActionFailure {
  /// Creates an [UnknownQuickActionTypeFailure].
  const UnknownQuickActionTypeFailure(this.quickActionTypeName);

  /// Raw id string received from the platform (expected to match [Enum.name] for a supported value).
  final String quickActionTypeName;

  @override
  String toString() {
    return 'UnknownQuickActionTypeFailure{quickActionTypeName: $quickActionTypeName}';
  }
}
