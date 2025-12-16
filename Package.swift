// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DenisVoice",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DenisVoice",
            targets: ["DenisVoice"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0"),
        .package(url: "https://github.com/xiph/opus.git", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "DenisVoice",
            dependencies: [
                "Starscream",
                "opus"
            ],
            path: "Sources/DenisVoice"
        ),
        .testTarget(
            name: "DenisVoiceTests",
            dependencies: ["DenisVoice"],
            path: "Tests/DenisVoiceTests"
        ),
    ]
)
