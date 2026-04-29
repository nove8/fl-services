import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:quick_action_service/src/failure/quick_action_failure.dart';

/// Mapper for converting platform quick action type strings to [Result]<[T]>.
final class QuickActionPlatformTypeNameToResultMapper<T extends Enum> {
  /// Creates a [QuickActionPlatformTypeNameToResultMapper].
  ///
  /// [supportedTypes] lists enum values used to resolve callback strings.
  QuickActionPlatformTypeNameToResultMapper(Iterable<T> supportedTypes)
    : _supportedTypes = supportedTypes.toList(growable: false);

  final List<T> _supportedTypes;

  /// Transforms [quickActionTypeName] from the platform to a [Result].
  Result<T> transform(String quickActionTypeName) {
    final T? quickActionType = _supportedTypes.firstWhereOrNull((T e) => e.name == quickActionTypeName);
    if (quickActionType != null) {
      return quickActionType.toSuccessResult();
    }
    return FailureResult(UnknownQuickActionTypeFailure(quickActionTypeName));
  }
}
