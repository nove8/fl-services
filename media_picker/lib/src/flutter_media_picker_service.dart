import 'dart:async';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:media_picker_service/src/entity/pick_media_source.dart';
import 'package:media_picker_service/src/failure/media_picker_failure.dart';
import 'package:media_picker_service/src/mapper/media_image_source_service_to_lib_mapper.dart';
import 'package:media_picker_service/src/media_picker_service.dart';
import 'package:media_picker_service/src/util/future_util.dart';

/// Maps a picked image file to a target value of type [T].
typedef _PickedFileMapper<T> = FutureOr<T?> Function(image_picker.XFile? pickedFile);

/// Flutter implementation of [MediaPickerService] using [ImagePicker].
final class FlutterMediaPickerService implements MediaPickerService {
  /// Creates a [FlutterMediaPickerService].
  FlutterMediaPickerService()
    : _imagePicker = image_picker.ImagePicker(),
        _pickMediaSourceServiceToLibMapper = const PickMediaSourceServiceToLibMapper();

  final image_picker.ImagePicker _imagePicker;
  final PickMediaSourceServiceToLibMapper _pickMediaSourceServiceToLibMapper;

  @override
  Future<Result<Uint8List?>> pickImageBytes(
    PickMediaSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickImageFileFromDevice(
      source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      pickedFileMapper: (image_picker.XFile? pickedFile) async => await pickedFile?.readAsBytes(),
    );
  }

  @override
  Future<Result<String?>> pickImagePath(
    PickMediaSource source, {
    double? maxWidth,
    double? maxHeight,
  }) {
    return _pickImageFileFromDevice(
      source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      pickedFileMapper: (image_picker.XFile? pickedFile) => pickedFile?.path,
    );
  }

  Future<Result<T?>> _pickImageFileFromDevice<T>(
    PickMediaSource source, {
    required _PickedFileMapper<T> pickedFileMapper,
    double? maxWidth,
    double? maxHeight,
  }) {
    return _imagePicker
        .pickImage(
          source: _pickMediaSourceServiceToLibMapper.transform(source),
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          requestFullMetadata: false,
        )
        .then(pickedFileMapper)
        .mapToResult(PickImageFailure.new);
  }
}
