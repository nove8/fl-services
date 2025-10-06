import 'package:async/async.dart';

/// A service interface for retrieving device-specific information.
abstract interface class DeviceInfoService {
  /// Retrieves the iOS identifier for vendor (IDFV) for the current device.
  Future<Result<String?>> getIosIdentifierForVendor();
}
