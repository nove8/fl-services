import 'package:async/async.dart';
import 'package:common_plugin/common_plugin.dart';
import 'package:common_result/common_result.dart';
import 'package:system_proxy_service/src/entity/system_proxy.dart';
import 'package:system_proxy_service/src/system_proxy_service.dart';

part 'mapper/system_proxy_mapper.dart';

/// Default implementation of [SystemProxyService] using the platform channel.
final class SystemProxyServiceImpl extends CommonPluginManager implements SystemProxyService {
  /// Creates an instance of [SystemProxyServiceImpl].
  SystemProxyServiceImpl() : super(_channelName);

  static const _SystemProxyMapper _systemProxyMapper = _SystemProxyMapper();

  // Channels
  static const String _channelName = 'system_proxy';

  // Methods
  static const String _getSystemProxyMethod = 'getSystemProxy';

  @override
  Future<Result<SystemProxy?>> getSystemProxy() {
    return invokeMethodForResult<Map<Object?, Object?>>(
      _getSystemProxyMethod,
    ).mapAsync(_systemProxyMapper.transform);
  }
}
