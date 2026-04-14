/// Supported image file extensions for sharing.
enum ShareImageExtension {
  /// PNG image format.
  png(fileExtension: '.png'),

  /// JPEG image format.
  jpeg(fileExtension: '.jpeg'),

  /// JPG image format.
  jpg(fileExtension: '.jpg'),

  /// GIF image format.
  gif(fileExtension: '.gif'),

  /// WebP image format.
  webp(fileExtension: '.webp'),

  /// BMP image format.
  bmp(fileExtension: '.bmp')
  ;

  const ShareImageExtension({required this.fileExtension});

  /// The file extension including the leading dot (e.g. `.png`).
  final String fileExtension;
}
