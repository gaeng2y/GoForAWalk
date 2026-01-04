// swift-tools-version:6.0
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSetting = PackageSettings(
    baseSettings: .settings(
        configurations: [
            .debug(name: .dev),
            .debug(name: .stage),
            .release(name: .prod)
        ]
    )
)
#endif

let package = Package(
    name: "Package",
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .upToNextMajor(from: "1.19.0")
        ),
        .package(
            url: "https://github.com/kakao/kakao-ios-sdk.git", 
            branch: "master"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(
                from: "5.0.0"
            )
        )
    ]
)
