import 'package:advertising_id/advertising_id.dart' as advertising_id;
import 'package:advertising_id_service/src/advertising_id_service.dart';
import 'package:advertising_id_service/src/failure/advertising_id_failure.dart';
import 'package:advertising_id_service/src/util/future_util.dart';
import 'package:async/async.dart';

/// Default implementation of [AdvertisingIdService] using the advertising_id package.
///
/// This implementation retrieves advertising identifiers without requesting
/// tracking authorization on iOS (ATT framework). It relies on existing permissions
/// and returns null if tracking is not authorized.
final class AdvertisingIdServiceImpl implements AdvertisingIdService {
  /// Creates an [AdvertisingIdServiceImpl]
  const AdvertisingIdServiceImpl();

  @override
  Future<Result<String?>> getAdvertisingId() {
    const bool shouldRequestTrackingAuthorization = false;
    return advertising_id.AdvertisingId.id(
      // ignore: avoid_redundant_argument_values
      shouldRequestTrackingAuthorization,
    ).mapToResult(GetAdvertisingIdFailure.new);
  }
}
