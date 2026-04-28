import 'package:async/async.dart';
import 'package:quick_action_service/src/entity/quick_action_config.dart';

/// Service interface for managing application quick actions
/// (long-press shortcuts on the app icon).
abstract interface class QuickActionService<QuickActionT extends Enum> {
  /// Stream that emits a [Result] with the clicked quick action [QuickActionConfig.actionType],
  /// or a failure when the native id does not match any supported enum value.
  Stream<Result<QuickActionT>> get clickedQuickActionStream;

  /// Replaces the application's current quick action items with [configs].
  Future<Result<void>> configureQuickActions(List<QuickActionConfig<QuickActionT>> configs);

  /// Disposes the service, closing internal stream controllers.
  Future<void> dispose();
}
