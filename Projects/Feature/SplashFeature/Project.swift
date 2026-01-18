import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SplashFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.SplashFeature),
            dependencies: [
                .domain(target: .AuthService, type: .interface),
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.SplashFeature),
            dependencies: [
                .feature(target: .SplashFeature, type: .interface),
                .domain(target: .AuthService, type: .interface),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .feature(.SplashFeature),
            dependencies: [
                .feature(target: .SplashFeature, type: .interface)
            ]
        ),
        .tests(
            module: .feature(.SplashFeature),
            dependencies: [
                .feature(target: .SplashFeature)
            ]
        ),
        .demo(
            module: .feature(.SplashFeature),
            dependencies: [
                .feature(target: .SplashFeature)
            ]
        )
    ]
)
