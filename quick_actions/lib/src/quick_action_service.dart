import 'package:async/async.dart';
import 'package:quick_action_service/src/entity/quick_action_shortcut_item.dart';

/// Service interface for managing application quick actions
/// (long-press shortcuts on the app icon).
abstract interface class QuickActionService {
  /// Stream that emits the [QuickActionShortcutItem.type] of a shortcut
  /// each time the user clicks one.
  Stream<String> getClickedShortcutTypeStream();

  /// Replaces the application's current shortcut items with [items].
  Future<Result<void>> setShortcutItems(List<QuickActionShortcutItem> items);

  /// Disposes the service, closing internal stream controllers.
  Future<void> dispose();
}
