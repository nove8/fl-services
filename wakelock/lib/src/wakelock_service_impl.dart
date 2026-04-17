import 'package:async/async.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_service/src/failure/wakelock_failure.dart';
import 'package:wakelock_service/src/util/future_util.dart';
import 'package:wakelock_service/src/wakelock_service.dart';

/// Default implementation of [WakelockService] using the wakelock_plus package.
final class WakelockServiceImpl implements WakelockService {
  /// Creates a [WakelockServiceImpl].
  const WakelockServiceImpl();

  @override
  Future<Result<void>> setWakelockEnabled({required bool isEnabled}) {
    return WakelockPlus.toggle(enable: isEnabled).mapToResult(SetWakelockEnabledFailure.new);
  }

  @override
  Future<Result<bool>> isEnabled() {
    return WakelockPlus.enabled.mapToResult(WakelockStatusCheckFailure.new);
  }
}
