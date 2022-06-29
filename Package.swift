// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LXSCommons",
    platforms: [
        .iOS(.v15), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "LXSCommons", targets: ["LXSCommons", "LXSLogging", "LXSRandom"]),
        .library(name: "LXSJson", targets: ["LXSJson"]),
        .library(name: "LXSGridGeometry", targets: ["LXSGridGeometry"]),
        .library(name: "LXSLinearAlgebra", targets: ["LXSLinearAlgebra"]),
        .library(name: "LXSPluginMP", targets: ["LXSPluginMP"]),
        .library(name: "LXSPluginSCN", targets: ["LXSPluginSCN"]),
        .library(name: "LXSUI", targets: ["LXSUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "LXSCommons", dependencies: []),
        .testTarget(name: "LXSCommonsTests", dependencies: ["LXSCommons"]),
        
        .target(name: "LXSJson", dependencies: []),
        .testTarget(name: "LXSJsonTests", dependencies: ["LXSJson"]),
        
        .target(name: "LXSLogging", dependencies: []),
        
        .target(name: "LXSRandom", dependencies: ["LXSCommons"]),
        .testTarget(name: "LXSRandomTests", dependencies: ["LXSRandom"]),
        
        .target(name: "LXSGridGeometry", dependencies: []),
        .testTarget(name: "LXSGridGeometryTests", dependencies: ["LXSGridGeometry"]),
        
        .target(name: "LXSLinearAlgebra", dependencies: ["LXSCommons"]),
        .testTarget(name: "LXSLinearAlgebraTests", dependencies: ["LXSLinearAlgebra"]),
        
        .target(name: "LXSPluginMP"),
        
        .target(name: "LXSPluginSCN"),
        
        .target(name: "LXSUI", dependencies: []),
    ]
)
