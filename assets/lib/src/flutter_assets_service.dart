import 'dart:async';
import 'dart:convert';

import 'package:assets_service/src/assets_service.dart';
import 'package:assets_service/src/context_provider.dart';
import 'package:assets_service/src/failure/assets_failure.dart';
import 'package:assets_service/src/util/future_util.dart';
import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Callback used to execute expensive parsing in a background isolate.
typedef AssetsServiceIsolateExecutor =
    Future<OutputT> Function<InputT, OutputT>(
      FutureOr<OutputT> Function(InputT input) action,
      InputT input, {
      String debugLabel,
    });

/// Flutter implementation of [AssetsService] using [AssetBundle].
final class FlutterAssetsService implements AssetsService {
  /// Creates a [FlutterAssetsService].
  ///
  /// [contextProvider] provides the current app [BuildContext] used to resolve [AssetBundle].
  /// [isolateExecutor] is used for heavy structured data parsing.
  const FlutterAssetsService({
    required ContextProvider contextProvider,
    AssetsServiceIsolateExecutor? isolateExecutor,
  }) : _contextProvider = contextProvider,
       _isolateExecutor = isolateExecutor;

  static const String _rootAssetPath = 'asset';

  static const int _maxResponseSizeForDeserializationInMainIsolate = 50 * 1024;

  final ContextProvider _contextProvider;
  final AssetsServiceIsolateExecutor? _isolateExecutor;

  BuildContext get _context => _contextProvider.context;

  AssetBundle get _assetBundle => DefaultAssetBundle.of(_context);

  @override
  Future<Result<String>> loadString(
    String assetPath, {
    bool isNeedToCache = true,
  }) {
    return _assetBundle
        .loadString(assetPath, cache: isNeedToCache)
        .mapToResult((_) => StringAssetDataLoadingFailure(assetPath));
  }

  @override
  Future<Result<Uint8List>> loadBytes(String assetPath) {
    return _assetBundle
        .load(assetPath)
        .mapToResult((_) {
          return AssetDataLoadingFailure(assetPath);
        })
        .mapAsync((ByteData byteData) {
          return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
        });
  }

  @override
  Future<Result<EntityT>> loadStructuredData<EntityT extends Object>(
    String assetPath, {
    required EntityT Function(Map<String, Object?> jsonMap) parser,
  }) {
    return loadBytes(assetPath).flatMapFuture((Uint8List bytesData) async {
      final AssetsServiceIsolateExecutor? isolateExecutor = _isolateExecutor;

      try {
        final Map<String, Object?> jsonMap =
            bytesData.lengthInBytes < _maxResponseSizeForDeserializationInMainIsolate ||
                isolateExecutor == null
            ? _decodeJsonMap(bytesData)
            : await isolateExecutor(
                _decodeJsonMap,
                bytesData,
                debugLabel: 'FlutterAssetsService.loadStructuredData($assetPath)',
              );

        return parser(jsonMap).toSuccessResult();
      } catch (error) {
        return FailureResult(StructuredAssetDataParsingFailure(error));
      }
    });
  }

  @override
  String buildFullAssetPath(String assetPath) => '$_rootAssetPath/$assetPath';
}

/// Decodes a JSON object from raw bytes.
///
/// This function must remain a top-level or static function because
/// `compute` cannot execute closures or instance methods that capture context.
Map<String, Object?> _decodeJsonMap(Uint8List bytes) {
  final String jsonString = utf8.decode(bytes);
  return jsonDecode(jsonString) as Map<String, Object?>;
}
