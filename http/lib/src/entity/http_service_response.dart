import 'dart:io';
import 'dart:typed_data';

/// Represents a response from an HTTP request.
final class HttpServiceResponse {
  /// Creates an [HttpServiceResponse].
  const HttpServiceResponse({
    required this.bodyBytes,
    required this.statusCode,
    required this.reasonPhrase,
    required this.headers,
  });

  /// The response body as raw bytes.
  final Uint8List bodyBytes;

  /// The HTTP status code of the response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String? reasonPhrase;

  /// The response headers.
  final Map<String, String> headers;

  /// Returns true if the status code is 200 (OK).
  bool get isOkStatusCode => statusCode == HttpStatus.ok;

  @override
  String toString() {
    return 'HttpServiceResponse{bodyBytes: $bodyBytes, statusCode: $statusCode, reasonPhrase: $reasonPhrase, headers: $headers}';
  }
}
