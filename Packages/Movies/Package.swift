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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.1"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/ayham-achami/CArchSwinject.git", branch: "feature/v-3.0.0")
    ],
    targets: [
        .target(
            name: "Movies",
            dependencies: [
                "TMDBCore",
                "TMDBUIKit",
                "Alamofire",
                "CArchSwinject",
                "AlamofireImage"
            ]
        ),
        .testTarget(
            name: "MoviesTests",
            dependencies: [
                "Movies"
            ]
        ),
    ]
)
