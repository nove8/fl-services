import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_service/src/failure/vibration_failure.dart';
import 'package:vibration_service/src/util/future_util.dart';
import 'package:vibration_service/src/vibration_service.dart';

/// Default implementation of [VibrationService] using the vibration package.
final class VibrationServiceImpl implements VibrationService {
  /// Creates a [VibrationServiceImpl].
  const VibrationServiceImpl();

  @override
  Future<Result<void>> performOneShotVibration({
    required Duration duration,
    required int amplitude,
  }) {
    return _ensureThereIsCustomVibrationsSupport().flatMapFuture((_) {
      return Vibration.vibrate(
        duration: duration.inMilliseconds,
        amplitude: amplitude,
      ).mapToResult(OneShotVibrationPerformingFailure.new);
    });
  }

  @override
  Future<Result<void>> performWaveFormVibration({
    required List<int> timings,
    required List<int> amplitudes,
  }) {
    return _ensureThereIsCustomVibrationsSupport().flatMapFuture((_) {
      return Vibration.vibrate(
        pattern: timings,
        intensities: amplitudes,
      ).mapToResult(WaveFormVibrationPerformingFailure.new);
    });
  }

  Future<Result<void>> _ensureThereIsCustomVibrationsSupport() {
    return Vibration.hasCustomVibrationsSupport()
        .mapToResult((_) => const HasNoCustomVibrationsSupportFailure())
        .flatMapAsync((bool hasCustomVibrationsSupport) {
          return hasCustomVibrationsSupport
              ? emptyResult
              : const HasNoCustomVibrationsSupportFailure().toFailureResult();
        });
  }
}
