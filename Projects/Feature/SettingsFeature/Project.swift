import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SettingsFeature.rawValue,
    targets: [
        .interface(module: .feature(.SettingsFeature)),
        .implements(
            module: .feature(.SettingsFeature),
            dependencies: [
                .feature(target: .SettingsFeature, type: .interface),
                .domain(target: .UserService, type: .interface),
                .domain(target: .UserService),
                .userInterface(target: .DesignSystem)
            ]
        ),
        .testing(
            module: .feature(.SettingsFeature),
            dependencies: [
                .feature(target: .SettingsFeature, type: .interface)
            ]
        ),
        .tests(
            module: .feature(.SettingsFeature),
            dependencies: [
                .feature(target: .SettingsFeature)
            ]
        ),
        .demo(
            module: .feature(.SettingsFeature),
            dependencies: [
                .feature(target: .SettingsFeature)
            ]
        )
    ]
)
