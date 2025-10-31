import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_service/src/failure/network_info_failure.dart';
import 'package:network_info_service/src/network_info_service.dart';
import 'package:network_info_service/src/util/future_util.dart';

/// Default implementation of [NetworkInfoService] using the connectivity_plus package.
final class NetworkInfoConnectivityPlusService implements NetworkInfoService {
  /// Creates a [NetworkInfoConnectivityPlusService].
  const NetworkInfoConnectivityPlusService();

  @override
  Future<Result<bool>> get isConnectedToTheInternet {
    return Connectivity()
        .checkConnectivity()
        .then(_isConnectedResults)
        .mapToResult(IsConnectedToTheInternetCheckFailure.new);
  }

  @override
  Stream<bool> get isConnectedToTheInternetStream {
    return _onConnectivityChanged.map(_isConnectedResults);
  }

  Stream<List<ConnectivityResult>> get _onConnectivityChanged => Connectivity().onConnectivityChanged;

  @override
  Future<void> waitForInternetConnection() async {
    final bool isConnected = await isConnectedToTheInternet.outputOrFalse;
    if (!isConnected) {
      await _onConnectivityChanged.firstWhere(_isConnectedResults);
    }
  }

  bool _isConnectedResults(List<ConnectivityResult> connectivityResults) {
    return connectivityResults.any((ConnectivityResult connectivityResult) {
      return connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile;
    });
  }
}
