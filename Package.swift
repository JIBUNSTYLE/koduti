// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "koduti",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/bannzai/XcodeProject.git", from: "0.1.5"),
        .package(url: "https://github.com/behrang/YamlSwift.git", from: "3.4.4"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "4.1.2"),
//        .package(url: "https://github.com/kylef/Commander.git", from: "0.9.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "koduti",
            dependencies: ["XcodeProject", "Yaml", "SwiftShell"]),
        .testTarget(
            name: "kodutiTests",
            dependencies: ["koduti"]),
    ]
)
