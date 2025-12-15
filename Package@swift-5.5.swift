// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CascableCoreSimulatedCamera",
    platforms: [.macOS(.v11), .iOS(.v14), .macCatalyst(.v15)],
    products: [.library(name: "CascableCoreSimulatedCamera", targets: ["CascableCoreSimulatedCamera"])],
    dependencies: [
        .package(url: "https://github.com/Cascable/cascablecore-distribution", from: "17.0.0")
    ], targets: [
        .binaryTarget(name: "CascableCoreSimulatedCamera", path: "CascableCoreSimulatedCamera.xcframework")
    ]
)
