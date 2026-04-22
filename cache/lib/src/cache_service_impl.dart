import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:cache_service/src/cache_service.dart';
import 'package:cache_service/src/failure/cache_failure.dart';
import 'package:cache_service/src/util/future_util.dart';
import 'package:cache_service/src/util/uri_util.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Default implementation of [CacheService] using the flutter_cache_manager package.
///
/// Uses a singleton pattern — the first call to the factory constructor
/// creates the instance, and subsequent calls return the same instance.
final class CacheServiceImpl implements CacheService {
  /// Creates a [CacheServiceImpl].
  ///
  /// [cacheKey] is used as the cache store identifier.
  /// [maxNrOfCacheObjects] limits the number of cached objects.
  /// [stalePeriod] defines how long a cached object is considered fresh.
  CacheServiceImpl({
    required String cacheKey,
    int maxNrOfCacheObjects = _maxNrOfCacheObjects,
    Duration stalePeriod = const Duration(days: _fiveYears),
  }) : _cacheManager = CacheManager(
         Config(
           cacheKey,
           maxNrOfCacheObjects: maxNrOfCacheObjects,
           stalePeriod: stalePeriod,
         ),
       );

  static const int _maxNrOfCacheObjects = 10000;
  static const int _fiveYears = 365 * 5;

  final CacheManager _cacheManager;

  @override
  Future<Result<File>> putFile({
    required String fileCacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  }) {
    return _putFile(
      cacheKey: fileCacheKey,
      fileBytes: fileBytes,
      fileExtension: fileExtension,
    ).mapToResult(PutFileToCacheFailure.new);
  }

  @override
  Future<Result<Uint8List>> putFileBytes({
    required String fileCacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  }) {
    return _putFile(
      cacheKey: fileCacheKey,
      fileBytes: fileBytes,
      fileExtension: fileExtension,
    ).mapToResult(PutFileToCacheFailure.new).mapFuture((File file) => file.readAsBytes());
  }

  @override
  Future<Result<void>> removeFile({required String fileCacheKey}) {
    return _cacheManager.removeFile(fileCacheKey).mapToResult(RemoveFileFromCacheFailure.new);
  }

  @override
  Future<Result<Uint8List>> getFileBytesFromCache({required String fileCacheKey}) {
    return _getFileInfoFromCache(
      fileCacheKey,
    ).flatMapNullValueAsyncToFailure(() => const MissingFileInCacheFailure()).mapFuture(_readFileBytes);
  }

  @override
  Future<Result<bool>> hasFileInCache({required String fileCacheKey}) {
    return _getFileInfoFromCache(fileCacheKey).mapAsync((FileInfo? fileInfo) => fileInfo != null);
  }

  @override
  Future<Result<File>> downloadFile({required Uri url, required String fileCacheKey}) {
    return _downloadFileResult(url: url, cacheKey: fileCacheKey).mapAsync((FileInfo fileInfo) => fileInfo.file);
  }

  @override
  Future<Result<Uint8List>> downloadFileBytes({required Uri url, required String fileCacheKey}) {
    return _downloadFileResult(url: url, cacheKey: fileCacheKey).mapFuture(_readFileBytes);
  }

  Future<File> _putFile({
    required String cacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  }) {
    return _cacheManager.putFile(
      cacheKey,
      fileBytes,
      fileExtension: fileExtension,
    );
  }

  Future<Result<FileInfo>> _downloadFileResult({required Uri url, required String cacheKey}) {
    return url.isNetwork
        ? _cacheManager.downloadFile(url.toString(), key: cacheKey).mapToResult(DownloadFileFailure.new)
        : CannotDownloadNotNetworkUriFailure(url).toFailureResultFuture();
  }

  Future<Result<FileInfo?>> _getFileInfoFromCache(String cacheKey) {
    return _cacheManager.getFileFromCache(cacheKey).mapToResult(GetFileFromCacheFailure.new);
  }

  Future<Uint8List> _readFileBytes(FileInfo fileInfo) => fileInfo.file.readAsBytes();
}
