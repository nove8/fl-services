import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:quick_action_service/src/entity/quick_action_config.dart';
import 'package:quick_action_service/src/failure/quick_action_failure.dart';
import 'package:quick_action_service/src/mapper/quick_action_config_to_quick_actions_shortcut_item_mapper.dart';
import 'package:quick_action_service/src/quick_action_service.dart';
import 'package:quick_action_service/src/util/future_util.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;
import 'package:rxdart/rxdart.dart';

/// Default implementation of [QuickActionService] backed by the
/// `quick_actions` Flutter plugin.
final class QuickActionServiceImpl<QuickActionT extends Enum> implements QuickActionService<QuickActionT> {
  /// Creates a [QuickActionServiceImpl] for [supportedTypes].
  ///
  /// The service converts enum values to native shortcut ids via `type.name`
  /// and resolves callback ids back by matching `name` against [supportedTypes].
  QuickActionServiceImpl({
    required Iterable<QuickActionT> supportedTypes,
  }) {
    _init(supportedTypes);
  }

  final quick_actions.QuickActions _quickActions = const quick_actions.QuickActions();
  final QuickActionConfigToQuickActionsShortcutItemMapper<QuickActionT> _quickActionConfigMapper =
      QuickActionConfigToQuickActionsShortcutItemMapper<QuickActionT>();
  final StreamController<Result<QuickActionT>> _clickedQuickActionController =
      BehaviorSubject<Result<QuickActionT>>(
    sync: true,
  );

  @override
  Stream<Result<QuickActionT>> get clickedQuickActionStream => _clickedQuickActionController.stream;

  @override
  Future<Result<void>> configureQuickActions(List<QuickActionConfig<QuickActionT>> configs) {
    final List<quick_actions.ShortcutItem> shortcutItems = configs
        .map(_quickActionConfigMapper.transform)
        .toList(growable: false);
    return _quickActions.setShortcutItems(shortcutItems).mapToResult(SetQuickActionsFailure.new);
  }

  @override
  Future<void> dispose() {
    return _clickedQuickActionController.close();
  }

  Future<void> _init(Iterable<QuickActionT> supportedTypes) {
    final List<QuickActionT> supportedQuickActionTypes = supportedTypes.toList(growable: false);
    return _quickActions.initialize((String quickActionTypeName) {
      final QuickActionT? quickActionType = supportedQuickActionTypes.firstWhereOrNull(
        (QuickActionT e) => e.name == quickActionTypeName,
      );
      if (quickActionType != null) {
        _clickedQuickActionController.add(quickActionType.toSuccessResult());
      } else {
        _clickedQuickActionController.add(
          FailureResult(UnknownQuickActionTypeFailure(quickActionTypeName)),
        );
      }
    });
  }
}
