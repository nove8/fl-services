import 'package:common_result/common_result.dart';

/// Base class for cache-related failures.
abstract class CacheFailure implements Failure {}

/// Failure that occurs when a requested file is not found in the cache.
final class MissingFileInCacheFailure implements CacheFailure {
  /// Creates a [MissingFileInCacheFailure].
  const MissingFileInCacheFailure();
}

/// Failure that occurs when putting a file into the cache fails.
final class PutFileToCacheFailure implements CacheFailure {
  /// Creates a [PutFileToCacheFailure].
  const PutFileToCacheFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'PutFileToCacheFailure{error: $error}';
  }
}

/// Failure that occurs when deleting a file from the cache fails.
final class DeleteFileFromCacheFailure implements CacheFailure {
  /// Creates a [DeleteFileFromCacheFailure].
  const DeleteFileFromCacheFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'DeleteFileToCacheFailure{error: $error}';
  }
}

/// Failure that occurs when retrieving a file from the cache fails.
final class GetFileFromCacheFailure implements CacheFailure {
  /// Creates a [GetFileFromCacheFailure].
  const GetFileFromCacheFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'GetFileFromCacheFailure{error: $error}';
  }
}

/// Failure that occurs when downloading a file fails.
final class DownloadFileFailure implements CacheFailure {
  /// Creates a [DownloadFileFailure].
  const DownloadFileFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'DownloadFileFailure{error: $error}';
  }
}

/// Failure that occurs when attempting to download a file from a non-network URI.
final class CannotDownloadNotNetworkUriFailure implements CacheFailure {
  /// Creates a [CannotDownloadNotNetworkUriFailure].
  const CannotDownloadNotNetworkUriFailure(this.uri);

  /// The non-network URI that was attempted.
  final Uri uri;

  @override
  String toString() {
    return 'CannotDownloadNotNetworkUriFailure{uri: $uri}';
  }
}
