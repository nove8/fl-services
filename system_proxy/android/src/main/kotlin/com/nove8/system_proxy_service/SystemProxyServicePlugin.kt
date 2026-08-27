package com.nove8.system_proxy_service

import com.nove8.plugins.common.CommonPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter plugin that reports the HTTP proxy configured in the system settings.
 *
 * Android exposes the Wi-Fi proxy of the active network through the standard
 * JVM proxy system properties.
 *
 * Extends [CommonPlugin] to use standardized channel naming and lifecycle management.
 */
class SystemProxyServicePlugin : CommonPlugin(CHANNEL_NAME) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            GET_SYSTEM_PROXY_METHOD -> result.success(getSystemProxy())
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getSystemProxy(): Map<String, Any?> {
        return mapOf(
            HOST_PARAM to System.getProperty(PROXY_HOST_PROPERTY),
            PORT_PARAM to System.getProperty(PROXY_PORT_PROPERTY)?.toIntOrNull(),
        )
    }

    private companion object {
        // Channels
        private const val CHANNEL_NAME = "system_proxy"

        // Methods
        private const val GET_SYSTEM_PROXY_METHOD = "getSystemProxy"

        // Params
        private const val HOST_PARAM = "host"
        private const val PORT_PARAM = "port"

        // Properties
        private const val PROXY_HOST_PROPERTY = "http.proxyHost"
        private const val PROXY_PORT_PROPERTY = "http.proxyPort"
    }
}
