import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:media_picker_service/src/entity/media_image_source.dart';

/// Maps [MediaImageSource] to plugin [ImageSource].
final class MediaImageSourceToImageSourceMapper {
  /// Creates a [MediaImageSourceToImageSourceMapper].
  const MediaImageSourceToImageSourceMapper();

  /// Transforms [source] to [ImageSource].
  image_picker.ImageSource transform(MediaImageSource source) {
    return switch (source) {
      MediaImageSource.camera => image_picker.ImageSource.camera,
      MediaImageSource.gallery => image_picker.ImageSource.gallery,
    };
  }
}
