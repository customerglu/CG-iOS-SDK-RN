// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "CustomerGluRN",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CustomerGluRN",
            targets: ["CustomerGluRN"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CustomerGluRN",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [.define("SPM")]),
        .testTarget(
            name: "CustomerGluRNTests",
            dependencies: ["CustomerGluRN"])
    ]
)
