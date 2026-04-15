import 'dart:typed_data';

import 'package:async/async.dart';

/// A service interface for sharing content via the platform's share sheet.
abstract interface class ShareService {
  /// Shares text content.
  Future<Result<void>> shareText({required String text});

  /// Shares a URI.
  Future<Result<void>> shareUri({required Uri uri});

  /// Shares an image from bytes with the given [imageNameWithExtension].
  Future<Result<void>> shareImage({
    required Uint8List imageBytes,
    required String imageNameWithExtension,
  });
}
