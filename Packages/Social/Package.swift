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
        .package(url: "https://github.com/ayham-achami/CRest.git", from: "3.0.0"),
        .package(url: "https://github.com/ayham-achami/CTexture.git", from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", from: "3.0.0")
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
                .product(name: "AsyncDisplayKit", package: "CTexture"),
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
    ],
    swiftLanguageVersions: [.v5]
)

let defaultSettings: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency=minimal")]
package.targets.forEach { target in
    if var settings = target.swiftSettings, !settings.isEmpty {
        settings.append(contentsOf: defaultSettings)
        target.swiftSettings = settings
    } else {
        target.swiftSettings = defaultSettings
    }
}
