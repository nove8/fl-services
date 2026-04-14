import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:media_picker_service/src/entity/media_image_source.dart';
import 'package:media_picker_service/src/failure/media_picker_failure.dart';
import 'package:media_picker_service/src/mapper/media_image_source_service_to_lib_mapper.dart';
import 'package:media_picker_service/src/media_picker_service.dart';
import 'package:media_picker_service/src/util/future_util.dart';

/// Maps a picked image file to a target value of type [T].
typedef PickedFileMapper<T> = FutureOr<T?> Function(image_picker.XFile? pickedFile);

/// Flutter implementation of [MediaPickerService] using [ImagePicker].
final class FlutterMediaPickerService implements MediaPickerService {
  /// Creates a [FlutterMediaPickerService].
  FlutterMediaPickerService()
    : _imagePicker = image_picker.ImagePicker(),
      _mediaImageSourceServiceToLibMapper = const MediaImageSourceServiceToLibMapper();

  final image_picker.ImagePicker _imagePicker;
  final MediaImageSourceServiceToLibMapper _mediaImageSourceServiceToLibMapper;

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
      mapPickedFile: (image_picker.XFile? pickedFile) async => await pickedFile?.readAsBytes(),
    );
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
      mapPickedFile: (image_picker.XFile? pickedFile) => pickedFile?.path,
    );
  }

  Future<Result<T?>> _pickImageFileFromDevice<T>(
    MediaImageSource source, {
    required PickedFileMapper<T> mapPickedFile,
    double? maxWidth,
    double? maxHeight,
  }) {
    return _imagePicker
        .pickImage(
          source: _mediaImageSourceServiceToLibMapper.transform(source),
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          requestFullMetadata: false,
        )
        .then(mapPickedFile)
        .mapToResult(PickImageFailure.new);
  }
}
