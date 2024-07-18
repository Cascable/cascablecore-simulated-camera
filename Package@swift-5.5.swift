// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CascableCoreSimulatedCamera",
    platforms: [.macOS(.v10_14), .iOS(.v12), .macCatalyst(.v15)],
    products: [.library(name: "CascableCoreSimulatedCamera", targets: ["CascableCoreSimulatedCamera"])],
    dependencies: [
        .package(name: "CascableCore", url: "https://github.com/Cascable/cascablecore-distribution", .upToNextMinor(from: "14.0.0"))
    ], targets: [
        .binaryTarget(name: "CascableCoreSimulatedCamera", path: "CascableCoreSimulatedCamera.xcframework")
    ]
)
