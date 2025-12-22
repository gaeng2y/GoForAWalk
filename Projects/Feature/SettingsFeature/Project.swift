import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SettingsFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.SettingsFeature),
            dependencies: [
                .domain(target: .AuthService, type: .interface),
                .domain(target: .UserService, type: .interface),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.SettingsFeature),
            dependencies: [
                .feature(target: .SettingsFeature, type: .interface),
                .domain(target: .AuthService, type: .interface),
                .domain(target: .UserService, type: .interface),
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
