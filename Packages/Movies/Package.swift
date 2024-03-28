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
        .package(url: "https://github.com/realm/SwiftLint", from: "0.54.0"),
        .package(url: "https://github.com/ayham-achami/CRest.git", from: "3.0.0"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.3.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", from: "3.0.0")
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
