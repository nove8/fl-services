import 'package:async/async.dart';
import 'package:quick_action_service/src/entity/quick_action_config.dart';

/// Service interface for managing application quick actions
/// (long-press shortcuts on the app icon).
abstract interface class QuickActionService<T extends Enum> {
  /// Stream that emits the [QuickActionConfig.type] of a quick action
  /// each time the user clicks one.
  Stream<T> get clickedQuickActionStream;

  /// Replaces the application's current quick action items with [configs].
  Future<Result<void>> configureQuickActions(List<QuickActionConfig<T>> configs);

  /// Disposes the service, closing internal stream controllers.
  Future<void> dispose();
}
