import 'package:common_result/common_result.dart';

/// Base class for deep links failure
sealed class DeepLinksFailure implements Failure {}

/// Failure during parsing deep link uri
final class InvalidDeepLinkUriFailure implements DeepLinksFailure {
  /// Creates a [InvalidDeepLinkUriFailure]
  const InvalidDeepLinkUriFailure(this._uriString);

  final String _uriString;

  @override
  String toString() {
    return 'InvalidDeepLinkUriFailure{_uriString: $_uriString}';
  }
}
