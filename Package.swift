// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "pearOs",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "pearOs", targets: ["pearOs"]),
    ],
    targets: [
        .target(
            name: "pearOs",
            path: "src"
        ),
    ]
)