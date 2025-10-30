import 'package:async/async.dart';

/// A service interface for making device vibration.
abstract interface class VibrationService {
  /// Vibrate with [duration] at [amplitude]. Amplitude is a range from 1 to 255, if supported.
  Future<Result<void>> performOneShotVibration({
    required Duration duration,
    required int amplitude,
  });

  /// Vibrate with pattern at intensities. Amplitude is a range from 1 to 255.
  /// Pattern must have even number of elements!
  Future<Result<void>> performWaveFormVibration({
    required List<int> timings,
    required List<int> amplitudes,
  });
}
