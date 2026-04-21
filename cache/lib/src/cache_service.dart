import 'dart:typed_data';

import 'package:async/async.dart';

/// A service interface for caching files on disk.
abstract interface class CacheService {
  /// Puts [fileBytes] in the cache under the given [cacheKey].
  ///
  /// [cacheKey] can be a URL, file path, or any other unique string.
  /// The [fileExtension] should be provided without a dot (e.g. `"jpg"`).
  ///
  /// Returns the bytes that were saved on disk.
  Future<Result<Uint8List>> putFile({
    required String cacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  });

  /// Removes a file from the cache by its [cacheKey].
  Future<Result<void>> removeFile({required String cacheKey});

  /// Retrieves file bytes from the cache by its [cacheKey].
  ///
  /// [cacheKey] can be a URL, file path, or any other unique string.
  Future<Result<Uint8List>> getFileBytesFromCache({required String cacheKey});

  /// Checks whether a file with the given [cacheKey] exists in the cache.
  ///
  /// [cacheKey] can be a URL, file path, or any other unique string.
  Future<Result<bool>> hasFileInCache({required String cacheKey});

  /// Downloads a file from the given [url] and stores it in the cache
  /// under the given [cacheKey].
  Future<Result<Uint8List>> downloadFile({required Uri url, required String cacheKey});
}
