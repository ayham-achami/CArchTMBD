// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMDBUIKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TMDBUIKit",
            targets: [
                "TMDBUIKit"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
        .package(url: "https://github.com/ayham-achami/CArch.git", branch: "feature/v-3.0.0"),
        .package(url: "https://github.com/ayham-achami/CUIKit.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "TMDBUIKit",
            dependencies: [
                "CArch",
                "CUIKit"
            ],
            resources: [
                .process("Resources/Images.xcassets"),
                .process("Resources/Colors.xcassets")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ], 
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
            ]
        ),
        .testTarget(
            name: "TMDBUIKitTests",
            dependencies: [
                "TMDBUIKit"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
