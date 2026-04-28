/// Representation of an item that should appear in
/// the application's quick action menu (long-press on the app icon).
final class QuickActionConfig<T extends Enum> {
  /// Creates a [QuickActionConfig].
  ///
  /// [type] is the quick action enum value that identifies this action.
  /// Its `name` is sent to native quick actions and returned back on click.
  /// [localizedTitle] is the user-visible title.
  /// [platformIconName] is the native icon resource name (without extension):
  /// - iOS: image set name in `ios/Runner/Assets.xcassets/<name>.imageset`
  /// - Android: drawable resource name in
  ///   `android/app/src/main/res/drawable*/<name>.(xml|png|webp)`
  const QuickActionConfig({
    required this.type,
    required this.localizedTitle,
    required this.platformIconName,
  });

  /// Enum value that identifies the quick action.
  final T type;

  /// User-visible title.
  final String localizedTitle;

  /// Native icon resource name without extension.
  ///
  /// Example: `start_program` means:
  /// - iOS: `ios/Runner/Assets.xcassets/start_program.imageset`
  /// - Android: `android/app/src/main/res/drawable*/start_program.(xml|png|webp)`
  final String platformIconName;
}
