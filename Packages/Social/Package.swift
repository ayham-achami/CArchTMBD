// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Social",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Social",
            targets: [
                "Social"
            ]
        ),
    ],
    dependencies: [
        .package(path: "../TMDBCore"),
        .package(path: "../TMDBUIKit"),
        .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
        .package(url: "https://github.com/shimastripe/Texture.git", from: "3.1.1"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/ayham-achami/CRest.git", branch: "feature/v-3.0.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "Social",
            dependencies: [
                "CRest",
                "TMDBCore",
                "TMDBUIKit",
                "CArchSwinject",
                "AlamofireImage",
                .product(name: "AsyncDisplayKit", package: "Texture"),
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "SocialTests",
            dependencies: [
                "Social"
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
