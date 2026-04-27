/// Representation of an item that should appear in
/// the application's quick action menu (long-press on the app icon).
final class QuickActionShortcutItem {
  /// Creates a [QuickActionShortcutItem].
  ///
  /// [type] is a unique string identifier for the shortcut. It is returned
  /// back when the shortcut is clicked.
  /// [localizedTitle] is the user-visible title.
  /// [iconName] is the platform icon resource name (without extension).
  const QuickActionShortcutItem({
    required this.type,
    required this.localizedTitle,
    required this.iconName,
  });

  /// Unique string identifier for the shortcut.
  final String type;

  /// User-visible title.
  final String localizedTitle;

  /// Platform icon resource name (without extension).
  final String iconName;
}
