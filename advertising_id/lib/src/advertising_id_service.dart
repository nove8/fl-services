import 'package:async/async.dart';

/// A service interface for retrieving advertising identifiers on mobile devices.
abstract interface class AdvertisingIdService {
  /// Retrieves the advertising identifier for the current device.
  Future<Result<String?>> getAdvertisingId();
}
