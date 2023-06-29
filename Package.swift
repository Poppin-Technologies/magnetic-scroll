// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MagneticScroll",
  platforms: [.iOS(.v14)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MagneticScroll",
      targets: ["MagneticScroll"]),
  ],
  dependencies: [
    .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", .upToNextMajor(from: "0.7.0")),
    .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "MagneticScroll",
      dependencies: [
        .product(name: "OrderedCollections", package: "swift-collections"),
        .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
      ]
    )
  ]
)
