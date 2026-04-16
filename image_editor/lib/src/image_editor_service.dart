import 'dart:typed_data';

import 'package:async/async.dart';

/// A service interface for editing images.
abstract interface class ImageEditorService {
  /// Crops the given [imageBytes] according to the specified parameters.
  ///
  /// [left] and [top] define the top-left corner of the crop area.
  /// [width] and [height] define the dimensions of the crop area.
  /// [rotateDegrees] optionally rotates the image before cropping.
  ///
  /// Returns a [Result] with the cropped image bytes on success.
  Future<Result<Uint8List>> cropImageBytes(
    Uint8List imageBytes, {
    required double left,
    required double top,
    required double width,
    required double height,
    int? rotateDegrees,
  });
}
