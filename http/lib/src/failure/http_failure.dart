import 'package:common_result/common_result.dart';

/// Base class for HTTP failures.
sealed class HttpFailure implements Failure {}

/// Base class for failures caused by unsuccessful HTTP status codes.
sealed class UnsuccessfulHttpStatusCodeFailure implements HttpFailure {
  /// Creates an [UnsuccessfulHttpStatusCodeFailure] with the status code and reason phrase.
  const UnsuccessfulHttpStatusCodeFailure(this.statusCode, this.reasonPhrase);

  /// The HTTP status code that caused the failure.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String? reasonPhrase;

  @override
  String toString() {
    return 'UnsuccessfulHttpStatusCodeFailure{statusCode: $statusCode, reasonPhrase: $reasonPhrase}';
  }
}

/// Failure that occurs when receiving a client error HTTP status code (4xx).
final class ClientErrorHttpStatusCodeFailure extends UnsuccessfulHttpStatusCodeFailure {
  /// Creates a [ClientErrorHttpStatusCodeFailure] with the status code and reason phrase.
  const ClientErrorHttpStatusCodeFailure(
    super.statusCode,
    super.reasonPhrase,
  );

  @override
  String toString() {
    return 'ClientErrorHttpStatusCodeFailure{statusCode: $statusCode, reasonPhrase: $reasonPhrase}';
  }
}

/// Failure that occurs when receiving a server error HTTP status code (5xx).
final class ServerErrorHttpStatusCodeFailure extends UnsuccessfulHttpStatusCodeFailure {
  /// Creates a [ServerErrorHttpStatusCodeFailure] with the status code and reason phrase.
  const ServerErrorHttpStatusCodeFailure(
    super.statusCode,
    super.reasonPhrase,
  );

  @override
  String toString() {
    return 'ServerErrorHttpStatusCodeFailure{statusCode: $statusCode, reasonPhrase: $reasonPhrase}';
  }
}

/// Failure that occurs when receiving an informational or redirection HTTP status code (1xx or 3xx).
final class InformationOrRedirectionHttpStatusCodeFailure extends UnsuccessfulHttpStatusCodeFailure {
  /// Creates an [InformationOrRedirectionHttpStatusCodeFailure] with the status code and reason phrase.
  const InformationOrRedirectionHttpStatusCodeFailure(
    super.statusCode,
    super.reasonPhrase,
  );

  @override
  String toString() {
    return 'InformationOrRedirectionHttpStatusCodeFailure{statusCode: $statusCode, reasonPhrase: $reasonPhrase}';
  }
}

/// Failure that occurs when an HTTP request fails to complete.
final class HttpRequestFailure implements HttpFailure {
  /// Creates an [HttpRequestFailure] with the underlying error.
  const HttpRequestFailure(this.error);

  /// The underlying error object from the HTTP request.
  final Object error;

  @override
  String toString() {
    return 'HttpRequestFailure{error: $error}';
  }
}

/// Failure that occurs when there is no network connection available.
final class NoNetworkConnectionFailure implements HttpFailure {
  /// Creates a [NoNetworkConnectionFailure].
  const NoNetworkConnectionFailure();
}
