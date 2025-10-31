import 'package:async/async.dart';
import 'package:haptic_service/src/entity/haptic_impact.dart';

/// A service interface for performing haptic on the device.
abstract interface class HapticService {
  /// An alphanumeric string that uniquely identifies a device to the app’s vendor.
  /// Available on iOS platform only. On other platforms will be [UnsupportedPlatformFailure].
  Future<Result<void>> performHapticImpact(HapticImpact hapticImpact);
}
