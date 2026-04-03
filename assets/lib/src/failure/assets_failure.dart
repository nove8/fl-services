import 'package:common_result/common_result.dart';

/// Base class for asset-related failures.
sealed class AssetsFailure implements Failure {}

/// Failure when loading a string asset.
final class StringAssetDataLoadingFailure implements AssetsFailure {
  /// Creates a [StringAssetDataLoadingFailure].
  const StringAssetDataLoadingFailure(this.path);

  /// The asset path that failed to load.
  final String path;

  @override
  String toString() {
    return 'StringAssetDataLoadingFailure{path: $path}';
  }
}

/// Failure when loading raw byte asset data.
final class AssetDataLoadingFailure implements AssetsFailure {
  /// Creates an [AssetDataLoadingFailure].
  const AssetDataLoadingFailure(this.path);

  /// The asset path that failed to load.
  final String path;

  @override
  String toString() {
    return 'AssetDataLoadingFailure{path: $path}';
  }
}

/// Failure when parsing structured asset data.
final class StructuredAssetDataParsingFailure implements AssetsFailure {
  /// Creates a [StructuredAssetDataParsingFailure].
  const StructuredAssetDataParsingFailure(this.error);

  /// Original parsing error.
  final Object error;

  @override
  String toString() {
    return 'StructuredAssetDataParsingFailure{error: $error}';
  }
}
