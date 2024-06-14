// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlKit",
    platforms: [.macOS(.v10_13)],
    products: [
        .library(name: "ControlKit", targets: ["ControlKit"])
    ], targets: [
        .target(name: "ControlKit"),
        .testTarget(name: "ControlKitTests", dependencies: ["ControlKit"]),
        .executableTarget(name: "Client", dependencies: ["ControlKit"], path: "Client")
    ], swiftLanguageVersions: [.v6]
)
