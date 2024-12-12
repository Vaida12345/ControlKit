// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlKit",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "ControlKit", targets: ["ControlKit"])
    ], dependencies: [
        .package(url: "https://www.github.com/Vaida12345/NativeImage", from: "1.0.0")
    ], targets: [
        .target(name: "ControlKit", dependencies: ["NativeImage"]),
        .testTarget(name: "ControlKitTests", dependencies: ["ControlKit"]),
        .executableTarget(name: "Client", dependencies: ["ControlKit"], path: "Client")
    ], swiftLanguageModes: [.v6]
)
