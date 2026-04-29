import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:quick_action_service/src/entity/quick_action_config.dart';
import 'package:quick_action_service/src/failure/quick_action_failure.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;

/// Mapper for converting a quick action [Enum] to the native shortcut `type` string ([Enum.name]).
final class QuickActionActionTypeToPlatformShortcutTypeMapper<ActionT extends Enum> {
  /// Creates a [QuickActionActionTypeToPlatformShortcutTypeMapper].
  const QuickActionActionTypeToPlatformShortcutTypeMapper();

  /// Transforms [actionType] to the native shortcut type string.
  String transform(ActionT actionType) => actionType.name;
}

/// Mapper for converting platform quick action type strings to [Result]<[T]>.
final class QuickActionPlatformTypeNameToResultMapper<ActionT extends Enum> {
  /// Creates a [QuickActionPlatformTypeNameToResultMapper].
  ///
  /// [supportedTypes] lists enum values used to resolve callback strings.
  QuickActionPlatformTypeNameToResultMapper(Iterable<ActionT> supportedTypes)
    : _supportedTypes = supportedTypes.toList(growable: false);

  final List<ActionT> _supportedTypes;

  /// Transforms [quickActionTypeName] from the platform to a [Result].
  Result<ActionT> transform(String quickActionTypeName) {
    final ActionT? quickActionType = _supportedTypes.firstWhereOrNull(
      (ActionT e) => e.name == quickActionTypeName,
    );
    return quickActionType != null
        ? quickActionType.toSuccessResult()
        : UnknownQuickActionTypeFailure(quickActionTypeName).toFailureResult();
  }
}

/// Mapper for converting [QuickActionConfig] to plugin [quick_actions.ShortcutItem].
final class QuickActionConfigToQuickActionsShortcutItemMapper<ActionT extends Enum> {
  /// Creates a [QuickActionConfigToQuickActionsShortcutItemMapper].
  QuickActionConfigToQuickActionsShortcutItemMapper()
    : _actionTypeToPlatformShortcutTypeMapper = QuickActionActionTypeToPlatformShortcutTypeMapper<ActionT>();

  final QuickActionActionTypeToPlatformShortcutTypeMapper<ActionT> _actionTypeToPlatformShortcutTypeMapper;

  /// Transforms [config] to [quick_actions.ShortcutItem].
  quick_actions.ShortcutItem transform(QuickActionConfig<ActionT> config) {
    return quick_actions.ShortcutItem(
      type: _actionTypeToPlatformShortcutTypeMapper.transform(config.actionType),
      localizedTitle: config.actionTitle,
      icon: config.actionPlatformIconName,
    );
  }
}
