import 'package:common_result/common_result.dart';

/// Base class for permission failures
sealed class VibrationFailure implements Failure {}

/// Failure that occurs in case device doesn't support custom vibrations.
final class HasNoCustomVibrationsSupportFailure implements VibrationFailure {
  /// Creates a [HasNoCustomVibrationsSupportFailure].
  const HasNoCustomVibrationsSupportFailure();
}

/// Failure class for errors occurring during performing one time vibration shot.
final class OneShotVibrationPerformingFailure implements VibrationFailure {
  /// Creates a [OneShotVibrationPerformingFailure].
  const OneShotVibrationPerformingFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'OneShotVibrationPerformingFailure{error: $error}';
  }
}

/// Failure for errors occurring during performing wave form vibration.
final class WaveFormVibrationPerformingFailure implements VibrationFailure {
  /// Creates a [WaveFormVibrationPerformingFailure].
  const WaveFormVibrationPerformingFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'WaveFormVibrationPerformingFailure{error: $error}';
  }
}
