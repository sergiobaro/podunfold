// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "podunfold",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "podunfold", targets: ["podunfold"]),
        .library(name: "PodUnfoldLib", targets: ["PodUnfoldLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.1")),
    ],
    targets: [
        .target(
            name: "podunfold", dependencies: ["PodUnfoldLib"]
        ),
        .target(
            name: "PodUnfoldLib", dependencies: ["Yams"]
        ),
        .testTarget(
            name: "PodUnfoldLibTests", dependencies: ["PodUnfoldLib", "Nimble", "Yams"]
        )
    ]
)