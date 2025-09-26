import 'package:async/async.dart';

/// A service interface for handling deep links in Flutter applications.
///
/// This service provides a reactive approach to deep link handling, allowing
/// applications to respond to incoming deep links throughout their lifecycle.
///
/// ## Features
/// - Reactive stream-based deep link handling
/// - Automatic parsing and validation of deep link URLs
/// - Error handling for malformed deep links
/// - Support for launch-time deep links (cold start)
/// - Support for runtime deep links (warm start)
abstract interface class DeepLinkService {
  /// A stream that emits deep link URLs when they are received by the application.
  ///
  /// This stream provides a reactive way to handle deep links throughout the app lifecycle.
  /// Each emitted value is wrapped in a [Result] to handle both successful URL parsing
  /// and potential failures gracefully.
  ///
  /// **Behavior:**
  /// - Emits [SuccessResult] containing a [Uri] when a valid deep link is received
  /// - Emits [FailureResult] with a [InvalidDeepLinkUriFailure] when URL parsing fails
  /// - May emit the initial deep link that launched the app (if any) upon initialization
  /// - Continues to emit new deep links received while the app is running
  Stream<Result<Uri>> get deepLinkUrlStream;
}
