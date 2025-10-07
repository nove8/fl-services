import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_service/src/failure/package_info_failure.dart';
import 'package:package_info_service/src/package_info_service.dart';
import 'package:package_info_service/src/util/future_util.dart';

/// Default implementation of [PackageInfoService] using the package_info_plus package.
final class PackageInfoPlusService implements PackageInfoService {
  /// Creates a [PackageInfoPlusService]
  const PackageInfoPlusService();

  @override
  Future<Result<String>> get packageName =>
      _packageInfo.mapAsync((PackageInfo packageInfo) => packageInfo.packageName);

  @override
  Future<Result<String>> get packageVersion =>
      _packageInfo.mapAsync((PackageInfo packageInfo) => packageInfo.version);

  Future<Result<PackageInfo>> get _packageInfo =>
      PackageInfo.fromPlatform().mapToResult(GetPackageInfoFailure.new);
}
