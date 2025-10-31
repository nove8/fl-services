import 'package:common_result/common_result.dart';

/// Base class for network info failures
sealed class NetworkInfoFailure implements Failure {}

/// Failure class for errors occurring during checking for internet connection.
final class IsConnectedToTheInternetCheckFailure implements NetworkInfoFailure {
  /// Creates a [IsConnectedToTheInternetCheckFailure].
  const IsConnectedToTheInternetCheckFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'IsConnectedToTheInternetCheckFailure{error: $error}';
  }
}
