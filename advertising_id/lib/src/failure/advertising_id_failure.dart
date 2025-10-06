import 'package:common_result/common_result.dart';

/// Base class for advertising ID failures
sealed class AdvertisingIdFailure implements Failure {}

/// Failure that occurs when retrieving the advertising ID from the platform
final class GetAdvertisingIdFailure implements AdvertisingIdFailure {
  /// Creates a [GetAdvertisingIdFailure] with the underlying error
  const GetAdvertisingIdFailure(this.error);

  /// The underlying error object from the platform API call
  final Object error;

  @override
  String toString() {
    return 'GetAdvertisingIdFailure{error: $error}';
  }
}
