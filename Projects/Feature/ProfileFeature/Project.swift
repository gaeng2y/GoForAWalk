import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.ProfileFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.ProfileFeature)
        ),
        .implements(
            module: .feature(.ProfileFeature),
            dependencies: [
                .feature(target: .ProfileFeature, type: .interface),
                .feature(target: .SettingsFeature),
                .domain(target: .UserService, type: .interface),
                .domain(target: .UserService),
                .userInterface(target: .DesignSystem)
            ]
        ),
        .testing(
            module: .feature(.ProfileFeature),
            dependencies: [
                .feature(target: .ProfileFeature, type: .interface)
            ]
        ),
        .tests(
            module: .feature(.ProfileFeature),
            dependencies: [
                .feature(target: .ProfileFeature)
            ]
        ),
        .demo(
            module: .feature(.ProfileFeature),
            dependencies: [
                .feature(target: .ProfileFeature)
            ]
        )
    ]
)
