import 'package:async/async.dart';
import 'package:haptic_service/src/entity/haptic_impact.dart';

/// A service interface for performing haptic on the device.
abstract interface class HapticService {
  /// Performing haptic impact.
  Future<Result<void>> performHapticImpact(HapticImpact hapticImpact);
}
