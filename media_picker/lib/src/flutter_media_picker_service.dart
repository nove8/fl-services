import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker_service/src/entity/media_image_source.dart';
import 'package:media_picker_service/src/failure/media_picker_failure.dart';
import 'package:media_picker_service/src/media_picker_service.dart';
import 'package:media_picker_service/src/util/future_util.dart';

/// Flutter implementation of [MediaPickerService] using [ImagePicker].
final class FlutterMediaPickerService implements MediaPickerService {
  /// Creates a [FlutterMediaPickerService].
  FlutterMediaPickerService();

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<Result<Uint8List?>> pickImageBytes(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickXFile(source, maxWidth: maxWidth, maxHeight: maxHeight)
        .then((XFile? pickedFile) async => await pickedFile?.readAsBytes())
        .mapToResult(PickImageServiceFailure.new);
  }

  @override
  Future<Result<String?>> pickImagePath(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickXFile(source, maxWidth: maxWidth, maxHeight: maxHeight)
        .then((XFile? pickedFile) => pickedFile?.path)
        .mapToResult(PickImageServiceFailure.new);
  }

  Future<XFile?> _pickXFile(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _imagePicker.pickImage(
      source: source._toImageSource(),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      requestFullMetadata: false,
    );
  }
}

extension on MediaImageSource {
  ImageSource _toImageSource() {
    return switch (this) {
      MediaImageSource.camera => ImageSource.camera,
      MediaImageSource.gallery => ImageSource.gallery,
    };
  }
}
