import 'package:async/async.dart';

/// A service interface for leaving a review for your app without needing to close it.
abstract interface class InAppReviewService {
  /// Attempts to show the review dialog.
  Future<Result<void>> requestReview();
}
