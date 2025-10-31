import 'package:async/async.dart';

/// A service interface for retrieving network information.
abstract interface class NetworkInfoService {
  /// Returns whether device is connected to the internet.
  Future<Result<bool>> get isConnectedToTheInternet;
}
