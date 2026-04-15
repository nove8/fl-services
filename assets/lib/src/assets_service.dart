import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';

/// A service interface for loading assets from the asset bundle.
abstract interface class AssetsService {
  /// Retrieve a string from the assets.
  ///
  /// If the [isNeedToCache] argument is set to false, then the data will not be
  /// cached, and reading the data may bypass the cache. This is useful if the
  /// caller is going to be doing its own caching. (It might not be cached if
  /// it's set to true either, that depends on the assets implementation.)
  ///
  /// String [assetPath] should be provided with root "assets" folder.
  Future<Result<String>> loadString(String assetPath, {bool isNeedToCache = true});

  /// Retrieve raw bytes from the assets.
  ///
  /// String [assetPath] should be provided with root "assets" folder.
  Future<Result<Uint8List>> loadBytes(String assetPath);

  /// Retrieve a string from the asset bundle, parse it with the given function,
  /// and return the function's result.
  /// If [isIsolateParse] is set to true, the JSON decoding will be performed
  /// in a background isolate if the asset size exceeds a certain threshold.
  Future<Result<EntityT>> loadStructuredData<EntityT extends Object>(
    String assetPath, {
    required EntityT Function(Map<String, Object?> jsonMap) parser,
    bool isIsolateParse = false,
  });

  /// Provides full asset path started from root "assets" folder.
  String buildFullAssetPath(String assetPath);
}
