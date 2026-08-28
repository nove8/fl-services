// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "system_proxy_service",
    products: [
        .library(name: "system-proxy-service", targets: ["system_proxy_service"]),
    ],
    dependencies: [
        .package(name: "common_plugin", path: "../common_plugin"),
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "system_proxy_service",
            dependencies: [
                .product(name: "common-plugin", package: "common_plugin"),
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
        ),
    ],
)
