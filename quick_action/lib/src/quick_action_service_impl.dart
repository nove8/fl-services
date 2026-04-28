import 'dart:async';

import 'package:async/async.dart';
import 'package:quick_action_service/src/entity/quick_action_config.dart';
import 'package:quick_action_service/src/failure/quick_action_failure.dart';
import 'package:quick_action_service/src/mapper/quick_action_config_to_quick_actions_shortcut_item_mapper.dart';
import 'package:quick_action_service/src/quick_action_service.dart';
import 'package:quick_action_service/src/util/future_util.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;
import 'package:rxdart/rxdart.dart';

/// Default implementation of [QuickActionService] backed by the
/// `quick_actions` Flutter plugin.
final class QuickActionServiceImpl<T extends Enum> implements QuickActionService<T> {
  /// Creates a [QuickActionServiceImpl] for [supportedTypes].
  ///
  /// The service converts enum values to native shortcut ids via `type.name`
  /// and maps callback ids back using [supportedTypes].
  QuickActionServiceImpl({
    required Iterable<T> supportedTypes,
  }) : _quickActionTypeByName = <String, T>{
         for (final T type in supportedTypes) type.name: type,
       } {
    _init();
  }

  final Map<String, T> _quickActionTypeByName;

  final quick_actions.QuickActions _quickActions = const quick_actions.QuickActions();
  final QuickActionConfigToQuickActionsShortcutItemMapper<T> _quickActionConfigMapper =
      QuickActionConfigToQuickActionsShortcutItemMapper<T>();
  final StreamController<T> _clickedQuickActionController = BehaviorSubject<T>(sync: true);

  @override
  Stream<T> get clickedQuickActionStream => _clickedQuickActionController.stream;

  @override
  Future<Result<void>> configureQuickActions(List<QuickActionConfig<T>> configs) {
    final List<quick_actions.ShortcutItem> shortcutItems = configs
        .map(_quickActionConfigMapper.transform)
        .toList(growable: false);
    return _quickActions.setShortcutItems(shortcutItems).mapToResult(SetQuickActionsFailure.new);
  }

  @override
  Future<void> dispose() {
    return _clickedQuickActionController.close();
  }

  Future<void> _init() {
    return _quickActions.initialize((String quickActionTypeName) {
      final T? quickActionType = _quickActionTypeByName[quickActionTypeName];
      if (quickActionType != null) {
        _clickedQuickActionController.add(quickActionType);
      }
    });
  }
}
