/// Mapper for converting a quick action [Enum] to the native shortcut `type` string ([Enum.name]).
final class QuickActionActionTypeToPlatformShortcutTypeMapper<T extends Enum> {
  /// Creates a [QuickActionActionTypeToPlatformShortcutTypeMapper].
  QuickActionActionTypeToPlatformShortcutTypeMapper();

  /// Transforms [actionType] to the native shortcut type string.
  String transform(T actionType) => actionType.name;
}
