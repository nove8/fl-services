import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:http_service/src/entity/http_service_response.dart';

/// A service interface for HTTP network requests.
abstract interface class HttpService {
  /// Performs an HTTP GET request to [url].
  /// [headers] are optional HTTP headers to include with the request.
  Future<Result<HttpServiceResponse>> get(
    Uri url, {
    Map<String, String>? headers,
  });

  /// Performs an HTTP POST request to [url].
  /// [body] is the optional request body to send.
  /// [headers] are optional HTTP headers to include with the request.
  Future<Result<HttpServiceResponse>> post(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
  });

  /// Performs an HTTP POST request with multipart form data to [url].
  /// [fields] are the form field values to include.
  /// [fileFieldNameToFileBytes] maps file field names to their binary content.
  /// [headers] are optional HTTP headers to include with the request.
  Future<Result<HttpServiceResponse>> postFormData(
    Uri url, {
    required Map<String, Uint8List> fileFieldNameToFileBytes,
    Map<String, String>? fields,
    Map<String, String>? headers,
  });

  /// Performs an HTTP PUT request to [url].
  /// [body] is the optional request body to send.
  /// [headers] are optional HTTP headers to include with the request.
  Future<Result<HttpServiceResponse>> put(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
  });

  /// Performs an HTTP DELETE request to [url].
  /// [body] is the optional request body to send.
  /// [headers] are optional HTTP headers to include with the request.
  Future<Result<HttpServiceResponse>> delete(
    Uri url, {
    Object? body,
    Map<String, String>? headers,
  });
}
