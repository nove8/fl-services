import 'package:common_result/common_result.dart';

/// Base class for package info failures
sealed class PackageInfoFailure implements Failure {}

/// Failure class for errors occurring during package info retrieval
final class GetPackageInfoFailure implements PackageInfoFailure {
  /// Created a [GetPackageInfoFailure].
  const GetPackageInfoFailure(this.error);

  /// The error that occurred.
  final Object error;

  @override
  String toString() {
    return 'GetPackageInfoFailure{error: $error}';
  }
}
