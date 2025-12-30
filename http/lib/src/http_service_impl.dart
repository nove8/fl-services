import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:http/http.dart' as http;
import 'package:http_service/src/entity/http_service_response.dart';
import 'package:http_service/src/entity/log_level.dart';
import 'package:http_service/src/entity/post_multipart_request.dart';
import 'package:http_service/src/failure/http_failure.dart';
import 'package:http_service/src/http_service.dart';
import 'package:http_service/src/util/future_util.dart';
import 'package:http_service/src/util/object_util.dart';
import 'package:network_info_service/network_info_connectivity_plus_service.dart';
import 'package:network_info_service/network_info_service.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart' as pretty_http_logger;

part 'mapper/log_level_mapper.dart';

/// Default implementation of [HttpService] using the http package.
final class HttpServiceImpl implements HttpService {
  /// Creates an [HttpServiceImpl].
  /// [networkInfoService] is used to check network connectivity before requests.
  /// [logLevel] controls the verbosity of HTTP request/response logging.
  HttpServiceImpl({required this.logLevel});

  static const _LogLevelServiceToLibMapper _logLevelServiceToLibMapper = _LogLevelServiceToLibMapper();
  static const NetworkInfoService _networkInfoService = NetworkInfoConnectivityPlusService();

  /// The log level for HTTP request/response logging.
  final LogLevel logLevel;

  late final pretty_http_logger.HttpWithMiddleware _httpWithMiddleware =
      pretty_http_logger.HttpWithMiddleware.build(
        middlewares: <pretty_http_logger.MiddlewareContract>[
          pretty_http_logger.HttpLogger(logLevel: _logLevelServiceToLibMapper.transform(logLevel)),
        ],
      );

  //FIXME: HttpClientWithMiddleware still exists during the session. Check future package improvements.
  late final pretty_http_logger.HttpClientWithMiddleware _httpClientWithMiddleware =
      pretty_http_logger.HttpClientWithMiddleware.build(
        middlewares: <pretty_http_logger.MiddlewareContract>[
          pretty_http_logger.HttpLogger(logLevel: _logLevelServiceToLibMapper.transform(logLevel)),
        ],
      );

  @override
  Future<Result<HttpServiceResponse>> get(
    Uri uri, {
    Map<String, String>? headers,
  }) {
    return _makeRequest(() {
      return _httpWithMiddleware.get(
        uri,
        headers: headers,
      );
    });
  }

  @override
  Future<Result<HttpServiceResponse>> post(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(() {
      return _httpWithMiddleware.post(
        uri,
        body: body,
        headers: headers,
      );
    });
  }

  @override
  Future<Result<HttpServiceResponse>> postFormData(
    Uri url, {
    required Map<String, Uint8List> fileFieldNameToFileBytes,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) {
    return _makeRequest(() {
      return _executeMultipartRequest(
        url,
        fileFieldNameToFileBytes,
        fields,
        headers,
      );
    });
  }

  @override
  Future<Result<HttpServiceResponse>> put(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(() {
      return _httpWithMiddleware.put(
        url,
        body: body,
        headers: headers,
      );
    });
  }

  @override
  Future<Result<HttpServiceResponse>> delete(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(() {
      return _httpWithMiddleware.delete(
        uri,
        body: body,
        headers: headers,
      );
    });
  }

  Future<Result<HttpServiceResponse>> _makeRequest(Future<http.Response> Function() request) async {
    final bool isConnectedToTheInternet = await _networkInfoService.isConnectedToTheInternet.outputOrFalse;

    return isConnectedToTheInternet
        ? request.call().mapToResult(HttpRequestFailure.new).flatMapAsync(_handleHttpResponse)
        : FailureResult(const NoNetworkConnectionFailure()).toFuture();
  }

  Future<http.Response> _executeMultipartRequest(
    Uri url,
    Map<String, Uint8List> fileFieldNameToFileBytes,
    Map<String, String>? fields,
    Map<String, String>? headers,
  ) {
    final PostMultipartRequest request = PostMultipartRequest.build(
      url: url,
      fileFieldNameToFileBytes: fileFieldNameToFileBytes,
      fields: fields,
      headers: headers,
    );

    return _httpClientWithMiddleware.multipart(request);
  }

  Result<HttpServiceResponse> _handleHttpResponse(http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode.isClientErrorCode) {
      return FailureResult(ClientErrorHttpStatusCodeFailure(statusCode, response.reasonPhrase));
    } else if (statusCode.isServerErrorCode) {
      return FailureResult(ServerErrorHttpStatusCodeFailure(statusCode, response.reasonPhrase));
    } else {
      return HttpServiceResponse(
        bodyBytes: response.bodyBytes,
        statusCode: statusCode,
        reasonPhrase: response.reasonPhrase,
        headers: response.headers,
      ).toSuccessResult();
    }
  }
}

/// Extension methods for HTTP status code classification.
extension _HttpStatusCodeIntExtension on int {
  /// Returns true if this status code represents a client error (4xx).
  bool get isClientErrorCode => this ~/ 100 == 4;

  /// Returns true if this status code represents a server error (5xx).
  bool get isServerErrorCode => this ~/ 100 == 5;
}
