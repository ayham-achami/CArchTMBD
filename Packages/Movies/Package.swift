// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Movies",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Movies",
            targets: [
                "Movies"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../TMDBCore"),
        .package(path: "../TMDBUIKit"),
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/ayham-achami/CRest.git", branch: "feature/v-3.0.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "Movies",
            dependencies: [
                "CRest",
                "TMDBCore",
                "TMDBUIKit",
                "CArchSwinject",
                "AlamofireImage"
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "MoviesTests",
            dependencies: [
                "Movies"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
