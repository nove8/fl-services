import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:haptic_service/src/entity/haptic_impact.dart';
import 'package:haptic_service/src/failure/haptic_failure.dart';
import 'package:haptic_service/src/haptic_service.dart';
import 'package:haptic_service/src/util/future_util.dart';

/// Default implementation of [HapticService] using flutter.
final class FlutterHapticService implements HapticService {
  /// Creates a [FlutterHapticService].
  const FlutterHapticService();

  @override
  Future<Result<void>> performHapticImpact(HapticImpact hapticImpact) {
    return switch (hapticImpact) {
      HapticImpact.light => HapticFeedback.lightImpact(),
      HapticImpact.medium => HapticFeedback.mediumImpact(),
      HapticImpact.heavy => HapticFeedback.heavyImpact(),
    }.mapToResult(HapticImpactPerformingFailure.new);
  }
}
