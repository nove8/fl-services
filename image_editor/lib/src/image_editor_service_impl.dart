import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:image_editor/image_editor.dart' as image_editor;
import 'package:image_editor_service/src/failure/image_editor_failure.dart';
import 'package:image_editor_service/src/image_editor_service.dart';
import 'package:image_editor_service/src/util/future_util.dart';

/// Flutter implementation of [ImageEditorService] using the [image_editor] package.
final class ImageEditorServiceImpl implements ImageEditorService {
  /// Creates a [ImageEditorServiceImpl].
  const ImageEditorServiceImpl();

  @override
  Future<Result<Uint8List>> cropImageBytes(
    Uint8List imageBytes, {
    required double left,
    required double top,
    required double width,
    required double height,
    int? rotateDegrees,
  }) {
    final image_editor.ImageEditorOption option = image_editor.ImageEditorOption();

    if (rotateDegrees != null) {
      option.addOption(image_editor.RotateOption(rotateDegrees));
    }

    // ignore:prefer-trailing-comma
    final ui.Rect cropRect = ui.Rect.fromLTWH(left, top, width, height);
    option.addOption(image_editor.ClipOption.fromRect(cropRect));

    return image_editor.ImageEditor.editImage(image: imageBytes, imageEditorOption: option)
        .mapToResult(CommonImageEditorFailure.new)
        .flatMapNullValueAsyncToFailure(() => const MissingResultImageEditorFailure());
  }
}
