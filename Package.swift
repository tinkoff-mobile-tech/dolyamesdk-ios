// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DolyameSDK",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "DolyameSDK",
            targets: ["DolyameSDK", "JuicyScoreFramework"])
    ],
    targets: [
        .binaryTarget(name: "DolyameSDK", path: "./Framework/DolyameSDK.xcframework"),
        .binaryTarget(name: "JuicyScoreFramework", path: "./Framework/JuicyScoreFramework.xcframework")
    ])
