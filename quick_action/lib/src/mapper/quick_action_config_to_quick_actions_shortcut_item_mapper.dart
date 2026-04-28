import 'package:quick_action_service/src/entity/quick_action_config.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;

/// Mapper for converting [QuickActionConfig] to plugin [quick_actions.ShortcutItem].
final class QuickActionConfigToQuickActionsShortcutItemMapper<T extends Enum> {
  /// Creates a [QuickActionConfigToQuickActionsShortcutItemMapper].
  const QuickActionConfigToQuickActionsShortcutItemMapper();

  /// Transforms [config] to [quick_actions.ShortcutItem].
  quick_actions.ShortcutItem transform(QuickActionConfig<T> config) {
    return quick_actions.ShortcutItem(
      type: config.type.name,
      localizedTitle: config.localizedTitle,
      icon: config.platformIconName,
    );
  }
}
