/// Representation of an item that should appear in
/// the application's quick action menu (long-press on the app icon).
final class QuickActionConfig<ActionT extends Enum> {
  /// Creates a [QuickActionConfig].
  ///
  /// [actionType] is the quick action enum value that identifies this action.
  /// Its `name` is sent to native quick actions and returned back on click.
  /// [actionTitle] is the user-visible title.
  /// [actionPlatformIconName] is the native icon resource name (without extension):
  /// - iOS: image set name in `ios/Runner/Assets.xcassets/<name>.imageset`
  /// - Android: drawable resource name in
  ///   `android/app/src/main/res/drawable*/<name>.(xml|png|webp)`
  const QuickActionConfig({
    required this.actionType,
    required this.actionTitle,
    required this.actionPlatformIconName,
  });

  /// Enum value that identifies the quick action.
  final ActionT actionType;

  /// User-visible title.
  final String actionTitle;

  /// Native icon resource name without extension.
  ///
  /// Example: `start_program` means:
  /// - iOS: `ios/Runner/Assets.xcassets/start_program.imageset`
  /// - Android: `android/app/src/main/res/drawable*/start_program.(xml|png|webp)`
  final String actionPlatformIconName;
}
