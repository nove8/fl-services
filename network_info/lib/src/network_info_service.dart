import 'package:async/async.dart';

/// A service interface for retrieving network information.
abstract interface class NetworkInfoService {
  /// Returns whether device is connected to the internet.
  Future<Result<bool>> get isConnectedToTheInternet;

  /// Returns stream whether device is connected to the internet.
  Stream<bool> get isConnectedToTheInternetStream;

  /// Waits for internet connection to appear.
  Future<void> waitForInternetConnection();
}
