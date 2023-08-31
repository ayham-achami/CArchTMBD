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
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "TMDBCore",
            dependencies: [
                "CArchSwinject"
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
