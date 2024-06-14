// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlKit",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "ControlKit", targets: ["ControlKit"])
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/GraphicsKit.git", branch: "main")
    ], targets: [
        .target(name: "ControlKit", dependencies: ["GraphicsKit"]),
        .testTarget(name: "ControlKitTests", dependencies: ["ControlKit"]),
        .executableTarget(name: "Client", dependencies: ["ControlKit"], path: "Client")
    ], swiftLanguageVersions: [.v6]
)
