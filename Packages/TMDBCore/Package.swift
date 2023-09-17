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
        .package(url: "https://github.com/ayham-achami/CRest.git", branch: "feature/adapt"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "TMDBCore",
            dependencies: [
                "CRest",
                "CArchSwinject"
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "TMDBCoreTests",
            dependencies: [
                "TMDBCore"
            ]
        ),
    ]
)
