import 'package:async/async.dart';
import 'package:quick_action_service/src/entity/quick_action_shortcut_item.dart';
import 'package:quick_action_service/src/failure/quick_action_failure.dart';
import 'package:quick_action_service/src/quick_action_service.dart';
import 'package:quick_action_service/src/util/future_util.dart';
import 'package:quick_actions/quick_actions.dart' as quick_actions;
import 'package:rxdart/rxdart.dart';

/// Default implementation of [QuickActionService] backed by the
/// `quick_actions` Flutter plugin.
final class QuickActionServiceImpl implements QuickActionService {
  /// Returns the singleton instance of [QuickActionServiceImpl].
  factory QuickActionServiceImpl() {
    return _instance ??= QuickActionServiceImpl._();
  }

  QuickActionServiceImpl._() {
    _init();
  }

  static QuickActionServiceImpl? _instance;

  final quick_actions.QuickActions _quickActions = const quick_actions.QuickActions();
  final BehaviorSubject<String> _clickedShortcutTypeSubject = BehaviorSubject<String>(sync: true);

  @override
  Stream<String> getClickedShortcutTypeStream() => _clickedShortcutTypeSubject;

  @override
  Future<Result<void>> setShortcutItems(List<QuickActionShortcutItem> items) {
    final List<quick_actions.ShortcutItem> shortcutItems = items
        .map(_obtainShortcutItem)
        .toList(growable: false);
    return _quickActions.setShortcutItems(shortcutItems).mapToResult(SetQuickActionsFailure.new);
  }

  @override
  Future<void> dispose() {
    return _clickedShortcutTypeSubject.close();
  }

  Future<void> _init() {
    return _quickActions.initialize(_clickedShortcutTypeSubject.add);
  }

  quick_actions.ShortcutItem _obtainShortcutItem(QuickActionShortcutItem item) {
    return quick_actions.ShortcutItem(
      type: item.type,
      localizedTitle: item.localizedTitle,
      icon: item.iconName,
    );
  }
}
