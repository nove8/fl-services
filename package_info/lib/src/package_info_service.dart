import 'package:async/async.dart';

/// A service interface for retrieving package information.
abstract interface class PackageInfoService {
  /// Retrieves the name of the application package.
  Future<Result<String>> get packageName;

  /// Retrieves the version of the application package.
  Future<Result<String>> get packageVersion;
}
