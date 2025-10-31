import 'package:common_result/common_result.dart';

/// Base class for haptic failures.
sealed class HapticFailure implements Failure {}

/// Failure that occurs when performing haptic impact.
final class HapticImpactPerformingFailure implements HapticFailure {
  /// Creates a [HapticImpactPerformingFailure].
  const HapticImpactPerformingFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'HapticImpactPerformingFailure{error: $error}';
  }
}
