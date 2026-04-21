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
  /// Creates a [CacheServiceImpl] singleton.
  ///
  /// [cacheKey] is used as the cache store identifier.
  /// [maxNrOfCacheObjects] limits the number of cached objects.
  /// [stalePeriod] defines how long a cached object is considered fresh.
  factory CacheServiceImpl({
    required String cacheKey,
    int maxNrOfCacheObjects = 666666666,
    Duration stalePeriod = const Duration(days: 666666),
  }) {
    return _instance ??= CacheServiceImpl._(
      cacheKey: cacheKey,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
      stalePeriod: stalePeriod,
    );
  }

  CacheServiceImpl._({
    required String cacheKey,
    required int maxNrOfCacheObjects,
    required Duration stalePeriod,
  }) : _cacheManager = CacheManager(
         Config(
           cacheKey,
           maxNrOfCacheObjects: maxNrOfCacheObjects,
           stalePeriod: stalePeriod,
         ),
       );

  static CacheServiceImpl? _instance;

  final CacheManager _cacheManager;

  @override
  Future<Result<Uint8List>> putFile({
    required String cacheKey,
    required Uint8List fileBytes,
    required String fileExtension,
  }) {
    return _cacheManager
        .putFile(
          cacheKey,
          fileBytes,
          fileExtension: fileExtension,
        )
        .mapToResult(PutFileToCacheFailure.new)
        .mapFuture((File file) => file.readAsBytes());
  }

  @override
  Future<Result<void>> removeFile({
    required String cacheKey,
  }) {
    return _cacheManager.removeFile(cacheKey).mapToResult(DeleteFileFromCacheFailure.new);
  }

  @override
  Future<Result<Uint8List>> getFileBytesFromCache({
    required String cacheKey,
  }) {
    return _getFileInfoFromCache(
      cacheKey,
    ).flatMapNullValueAsyncToFailure(() => const MissingFileInCacheFailure()).mapFuture(_readFileBytes);
  }

  @override
  Future<Result<bool>> hasFileInCache({
    required String cacheKey,
  }) {
    return _getFileInfoFromCache(cacheKey).mapAsync((FileInfo? fileInfo) => fileInfo != null);
  }

  @override
  Future<Result<Uint8List>> downloadFile({
    required Uri url,
    required String cacheKey,
  }) {
    return url.isNetwork
        ? _cacheManager
              .downloadFile(url.toString(), key: cacheKey)
              .then(_readFileBytes)
              .mapToResult(DownloadFileFailure.new)
        : .value(FailureResult(CannotDownloadNotNetworkUriFailure(url)));
  }

  Future<Result<FileInfo?>> _getFileInfoFromCache(String cacheKey) {
    return _cacheManager.getFileFromCache(cacheKey).mapToResult(GetFileFromCacheFailure.new);
  }

  Future<Uint8List> _readFileBytes(FileInfo fileInfo) => fileInfo.file.readAsBytes();
}
