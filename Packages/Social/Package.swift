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
            targets: ["Social"]
        ),
    ],
    dependencies: [
        .package(path: "../TMDBCore"),
        .package(path: "../TMDBUIKit"),
        .package(url: "https://github.com/shimastripe/Texture.git", from: "3.1.1"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.1"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "Social",
            dependencies: [
                "TMDBCore",
                "TMDBUIKit",
                "Alamofire",
                "CArchSwinject",
                "AlamofireImage",
                .product(name: "AsyncDisplayKit", package: "Texture"),
            ]
        ),
        .testTarget(
            name: "SocialTests",
            dependencies: [
                "Social"
            ]
        ),
    ]
)
