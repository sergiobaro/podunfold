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
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "podunfold", dependencies: ["PodUnfoldLib"]
        ),
        .target(
            name: "PodUnfoldLib", dependencies: ["Yams"]
        ),
        .testTarget(
            name: "PodUnfoldLibTests", dependencies: ["PodUnfoldLib"]
        )
    ]
)
