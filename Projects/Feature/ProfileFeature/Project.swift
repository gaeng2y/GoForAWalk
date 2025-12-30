import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.ProfileFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.ProfileFeature),
            dependencies: [
                .domain(target: .UserService, type: .interface),
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.ProfileFeature),
            dependencies: [
                .feature(target: .ProfileFeature, type: .interface),
                .domain(target: .UserService, type: .interface),
                .shared(target: .GlobalThirdPartyLibrary)
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
