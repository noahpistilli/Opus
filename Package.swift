// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Opus",
    platforms: [
        .macOS(.v10_12),
    ],
    products: [
        .library(
            name: "Opus",
            targets: ["Opus"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nuclearace/copus", .upToNextMinor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "Opus",
            dependencies: ["ConfigureCoder", .product(name: "COPUS", package: "copus")]
        ),
        .target(name: "ConfigureCoder")
    ]
)
