// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMDBCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TMDBCore",
            targets: [
                "TMDBCore"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
        .package(url: "https://github.com/ayham-achami/CRest.git", branch: "feature/v-3.0.0"),
        .package(url: "https://github.com/ayham-achami/CFoundation.git", branch: "feature/3.0.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "TMDBCore",
            dependencies: [
                "CRest",
                "CFoundation",
                "CArchSwinject"
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "TMDBCoreTests",
            dependencies: [
                "TMDBCore"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
