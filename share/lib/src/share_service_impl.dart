import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_service/src/failure/share_failure.dart';
import 'package:share_service/src/share_service.dart';
import 'package:share_service/src/util/future_util.dart';

/// Default implementation of [ShareService] using share_plus package.
final class ShareServiceImpl implements ShareService {
  /// Creates a [ShareServiceImpl].
  const ShareServiceImpl();

  @override
  Future<Result<void>> shareImage({
    required Uint8List imageBytes,
    required String imageNameWithExtension,
  }) {
    final XFile xFile = XFile.fromData(imageBytes);
    return _share(
      ShareParams(
        files: <XFile>[xFile],
        fileNameOverrides: <String>[imageNameWithExtension],
      ),
    );
  }

  @override
  Future<Result<void>> shareText({required String text}) {
    return _share(ShareParams(text: text));
  }

  @override
  Future<Result<void>> shareUri({required Uri uri}) {
    return _share(ShareParams(uri: uri));
  }

  Future<Result<void>> _share(ShareParams shareParams) {
    return SharePlus.instance.share(shareParams).mapToResult(OtherShareFailure.new).flatMapAsync((
      ShareResult result,
    ) {
      return switch (result.status) {
        ShareResultStatus.success => emptyResult,
        ShareResultStatus.dismissed => const SharingDismissedFailure().toFailureResult(),
        ShareResultStatus.unavailable => const UnavailableToShareFailure().toFailureResult(),
      };
    });
  }
}
