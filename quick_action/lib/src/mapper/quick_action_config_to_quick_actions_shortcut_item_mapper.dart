import 'package:quick_action_service/src/entity/quick_action_config.dart';
import 'package:quick_action_service/src/mapper/quick_action_action_type_to_platform_shortcut_type_mapper.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;

/// Mapper for converting [QuickActionConfig] to plugin [quick_actions.ShortcutItem].
final class QuickActionConfigToQuickActionsShortcutItemMapper<T extends Enum> {
  /// Creates a [QuickActionConfigToQuickActionsShortcutItemMapper].
  QuickActionConfigToQuickActionsShortcutItemMapper()
    : _actionTypeToPlatformShortcutTypeMapper = QuickActionActionTypeToPlatformShortcutTypeMapper<T>();

  final QuickActionActionTypeToPlatformShortcutTypeMapper<T> _actionTypeToPlatformShortcutTypeMapper;

  /// Transforms [config] to [quick_actions.ShortcutItem].
  quick_actions.ShortcutItem transform(QuickActionConfig<T> config) {
    return quick_actions.ShortcutItem(
      type: _actionTypeToPlatformShortcutTypeMapper.transform(config.actionType),
      localizedTitle: config.actionTitle,
      icon: config.actionPlatformIconName,
    );
  }
}
