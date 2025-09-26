import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:deep_link_service/src/deep_link_service.dart';
import 'package:deep_link_service/src/failure/deep_link_failure.dart';
import 'package:rxdart/rxdart.dart';

/// Implementation of deep link service with app_links package
final class AppLinksDeepLinkService implements DeepLinkService {
  /// Creates a [AppLinksDeepLinkService]
  AppLinksDeepLinkService() {
    _init();
  }

  final AppLinks _appLinks = AppLinks();

  final StreamController<Result<Uri>> _deepLinkUrlController = BehaviorSubject<Result<Uri>>(sync: true);

  StreamSubscription<void>? _deepLinkUrlSubscription;

  @override
  Stream<Result<Uri>> get deepLinkUrlStream => _deepLinkUrlController.stream;

  /// Disposes the service, cancels stream subscriptions and closes stream controllers
  void dispose() {
    _deepLinkUrlSubscription?.cancel();
    _deepLinkUrlController.close();
  }

  Future<void> _init() async {
    await _addLatestDeepLinkIfNeeded();
    _deepLinkUrlSubscription = _appLinks.stringLinkStream.listen(_addNewDeepLinkUrl);
  }

  Future<void> _addLatestDeepLinkIfNeeded() async {
    final String? latestDeepLinkUriString = await _appLinks.getLatestLinkString().onError((_, _) => null);
    if (latestDeepLinkUriString != null) {
      _addNewDeepLinkUrl(latestDeepLinkUriString);
    }
  }

  void _addNewDeepLinkUrl(String uriString) {
    final Result<Uri> uriResult = _obtainDeepLinkUriFromString(uriString);
    _deepLinkUrlController.add(uriResult);
  }

  Result<Uri> _obtainDeepLinkUriFromString(String uriString) {
    final Uri? uri = Uri.tryParse(uriString);
    return uri != null ? uri.toSuccessResult() : InvalidDeepLinkUriFailure(uriString).toFailureResult();
  }
}
