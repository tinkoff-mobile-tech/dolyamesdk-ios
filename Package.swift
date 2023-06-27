// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "DolyameSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "DolyameSDK",
            targets: ["DolyameSDK"]
        )
    ],
    targets: [
        .binaryTarget(name: "DolyameSDK", path: "./Framework/DolyameSDK.xcframework")
    ]
)
