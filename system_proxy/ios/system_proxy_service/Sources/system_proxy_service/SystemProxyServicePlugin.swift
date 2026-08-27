import Flutter
import common_plugin

/**
 Flutter plugin that reports the HTTP proxy configured in the system settings.

 iOS exposes the proxy of the active network through `CFNetworkCopySystemProxySettings`.
 Only a manually configured proxy is reported, an automatic configuration (PAC) is ignored.
 */
public class SystemProxyServicePlugin: CommonPlugin, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        CommonPlugin.register(with: registrar, plugin: SystemProxyServicePlugin())
    }

    public override class var pluginKey: String { "SystemProxyServicePlugin" }

    public override var channelName: String { SystemProxyServicePlugin.CHANNEL_NAME }

    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case SystemProxyServicePlugin.GET_SYSTEM_PROXY_METHOD:
            result(getSystemProxy())
        default:
            super.handle(call, result: result)
        }
    }

    private func getSystemProxy() -> [String: Any?] {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: AnyObject],
              settings[SystemProxyServicePlugin.HTTP_ENABLE_SETTING] as? Bool == true
        else {
            return [:]
        }

        return [
            SystemProxyServicePlugin.HOST_PARAM: settings[SystemProxyServicePlugin.HTTP_PROXY_SETTING] as? String,
            SystemProxyServicePlugin.PORT_PARAM: settings[SystemProxyServicePlugin.HTTP_PORT_SETTING] as? Int,
        ]
    }

    // Channels
    private static let CHANNEL_NAME = "system_proxy"

    // Methods
    private static let GET_SYSTEM_PROXY_METHOD = "getSystemProxy"

    // Params
    private static let HOST_PARAM = "host"
    private static let PORT_PARAM = "port"

    // Settings
    private static let HTTP_ENABLE_SETTING = "HTTPEnable"
    private static let HTTP_PROXY_SETTING = "HTTPProxy"
    private static let HTTP_PORT_SETTING = "HTTPPort"
}
