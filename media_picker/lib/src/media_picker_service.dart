import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:media_picker_service/src/entity/media_image_source.dart';

/// A service interface for picking media from the device.
abstract interface class MediaPickerService {
  /// Picks an image from the given [source] and returns the image bytes.
  ///
  /// Returns `null` as a successful result if the user hasn't picked any image.
  /// [maxWidth] and [maxHeight] can be used to constrain the image dimensions.
  Future<Result<Uint8List?>> pickImageBytes(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  });

  /// Picks an image from the given [source] and returns the file path.
  ///
  /// Returns `null` as a successful result if the user hasn't picked any image.
  /// [maxWidth] and [maxHeight] can be used to constrain the image dimensions.
  Future<Result<String?>> pickImagePath(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  });
}
