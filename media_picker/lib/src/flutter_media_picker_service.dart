import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:media_picker_service/src/entity/media_image_source.dart';
import 'package:media_picker_service/src/failure/media_picker_failure.dart';
import 'package:media_picker_service/src/mapper/media_image_source_to_image_source_mapper.dart';
import 'package:media_picker_service/src/media_picker_service.dart';
import 'package:media_picker_service/src/util/future_util.dart';

/// Flutter implementation of [MediaPickerService] using [ImagePicker].
final class FlutterMediaPickerService implements MediaPickerService {
  /// Creates a [FlutterMediaPickerService].
  FlutterMediaPickerService()
    : _imagePicker = image_picker.ImagePicker(),
      _mediaImageSourceToImagePickerSourceMapper = const MediaImageSourceToImageSourceMapper();

  final image_picker.ImagePicker _imagePicker;
  final MediaImageSourceToImageSourceMapper _mediaImageSourceToImagePickerSourceMapper;

  @override
  Future<Result<Uint8List?>> pickImageBytes(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickImageFileFromDevice(
          source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        )
        .then((image_picker.XFile? pickedFile) async => await pickedFile?.readAsBytes())
        .mapToResult(PickImageServiceFailure.new);
  }

  @override
  Future<Result<String?>> pickImagePath(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickImageFileFromDevice(
      source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    ).then((image_picker.XFile? pickedFile) => pickedFile?.path).mapToResult(PickImageServiceFailure.new);
  }

  Future<image_picker.XFile?> _pickImageFileFromDevice(
    MediaImageSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _imagePicker.pickImage(
      source: _mediaImageSourceToImagePickerSourceMapper.transform(source),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      requestFullMetadata: false,
    );
  }
}
