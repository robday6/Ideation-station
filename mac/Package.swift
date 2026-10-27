// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Ideate",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(name: "Ideate", path: "Sources/Ideate")
    ]
)
