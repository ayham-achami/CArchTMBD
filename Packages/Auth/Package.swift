// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Auth",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Auth",
            targets: [
                "Auth"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../TMDBCore"),
        .package(path: "../TMDBUIKit"),
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
        .package(url: "https://github.com/ayham-achami/CRest.git", branch: "feature/v-3.0.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
        
    ],
    targets: [
        .target(
            name: "Auth",
            dependencies: [
                "CRest",
                "TMDBCore",
                "TMDBUIKit",
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
            name: "AuthTests",
            dependencies: [
                "Auth"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)


