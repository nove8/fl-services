import 'package:async/async.dart';

/// A service interface for getting deep links.
abstract interface class DeepLinkService {
  /// A stream emitting deep links
  Stream<Result<Uri>> get deepLinkUrlStream;
}
