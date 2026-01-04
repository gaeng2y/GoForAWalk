import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SignIn.rawValue,
    targets: [
        .interface(
            module: .feature(.SignIn),
            dependencies: [
                .domain(target: .AuthService, type: .interface),
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.SignIn),
            dependencies: [
                .feature(target: .SignIn, type: .interface),
                .domain(target: .AuthService, type: .interface)
            ]
        ),
        .tests(module: .feature(.SignIn), dependencies: [
            .feature(target: .SignIn),
            .domain(target: .AuthService, type: .testing)
        ])
    ]
)
