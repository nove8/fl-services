import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';

/// A service interface for caching files on disk.
abstract interface class CacheService {
  /// Puts [fileBytes] in the cache under the given [fileCacheKey].
  ///
  /// [fileCacheKey] can be a URL, file path, or any other unique string.
  /// The [fileExtension] should be provided without a dot (e.g. `"jpg"`).
  ///
  /// Returns the cached [File].
  Future<Result<File>> putFile({
    required String fileCacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  });

  /// Puts [fileBytes] in the cache under the given [fileCacheKey].
  ///
  /// [fileCacheKey] can be a URL, file path, or any other unique string.
  /// The [fileExtension] should be provided without a dot (e.g. `"jpg"`).
  ///
  /// Returns the cached file content as bytes.
  Future<Result<Uint8List>> putFileBytes({
    required String fileCacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  });

  /// Removes a file from the cache by its [fileCacheKey].
  Future<Result<void>> removeFile({required String fileCacheKey});

  /// Retrieves file bytes from the cache by its [fileCacheKey].
  ///
  /// [fileCacheKey] can be a URL, file path, or any other unique string.
  Future<Result<Uint8List>> getFileBytesFromCache({required String fileCacheKey});

  /// Checks whether a file with the given [fileCacheKey] exists in the cache.
  ///
  /// [fileCacheKey] can be a URL, file path, or any other unique string.
  Future<Result<bool>> hasFileInCache({required String fileCacheKey});

  /// Downloads a file from the given [url] and stores it in the cache
  /// under the given [fileCacheKey].
  ///
  /// Returns the cached [File].
  Future<Result<File>> downloadFile({required Uri url, required String fileCacheKey});

  /// Downloads a file from the given [url] and stores it in the cache
  /// under the given [fileCacheKey].
  ///
  /// Returns the cached file content as bytes.
  Future<Result<Uint8List>> downloadFileBytes({required Uri url, required String fileCacheKey});
}
