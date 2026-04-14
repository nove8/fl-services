import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:media_picker_service/src/entity/pick_media_source.dart';

/// Maps [PickMediaSource] to plugin [ImageSource].
final class PickMediaSourceServiceToLibMapper {
  /// Creates a [PickMediaSourceServiceToLibMapper].
  const PickMediaSourceServiceToLibMapper();

  /// Transforms [source] to [ImageSource].
  image_picker.ImageSource transform(PickMediaSource source) {
    return switch (source) {
      PickMediaSource.camera => image_picker.ImageSource.camera,
      PickMediaSource.gallery => image_picker.ImageSource.gallery,
    };
  }
}
