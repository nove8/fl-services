/// Supported image file extensions for sharing.
enum ShareImageExtension {
  /// PNG image format.
  png(fileExtension: '.png', mimeType: 'image/png'),

  /// JPEG image format.
  jpeg(fileExtension: '.jpeg', mimeType: 'image/jpeg'),

  /// JPG image format.
  jpg(fileExtension: '.jpg', mimeType: 'image/jpeg'),

  /// GIF image format.
  gif(fileExtension: '.gif', mimeType: 'image/gif'),

  /// WebP image format.
  webp(fileExtension: '.webp', mimeType: 'image/webp'),

  /// BMP image format.
  bmp(fileExtension: '.bmp', mimeType: 'image/bmp')
  ;

  const ShareImageExtension({
    required this.fileExtension,
    required this.mimeType,
  });

  /// The file extension including the leading dot (e.g. `.png`).
  final String fileExtension;

  /// The MIME type of the image format (e.g. `image/png`).
  final String mimeType;
}
