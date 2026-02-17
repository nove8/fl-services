import 'package:async/async.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_review_service/src/failure/in_app_review_failure.dart';
import 'package:in_app_review_service/src/in_app_review_service.dart';
import 'package:in_app_review_service/src/util/future_util.dart';

/// Default implementation of [InAppReviewService] using in_app_review package.
final class InAppReviewServiceImpl implements InAppReviewService {
  /// Creates a [InAppReviewServiceImpl].
  const InAppReviewServiceImpl();

  @override
  Future<Result<void>> requestReview() {
    return InAppReview.instance.requestReview().mapToResult(RequestInAppReviewFailure.new);
  }
}
