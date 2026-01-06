import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SplashFeature.rawValue,
    targets: [
        .interface(module: .feature(.SplashFeature)),
        .implements(module: .feature(.SplashFeature), dependencies: [
            .feature(target: .SplashFeature, type: .interface)
        ]),
        .testing(module: .feature(.SplashFeature), dependencies: [
            .feature(target: .SplashFeature, type: .interface)
        ]),
        .tests(module: .feature(.SplashFeature), dependencies: [
            .feature(target: .SplashFeature)
        ]),
        .demo(module: .feature(.SplashFeature), dependencies: [
            .feature(target: .SplashFeature)
        ])
    ]
)
