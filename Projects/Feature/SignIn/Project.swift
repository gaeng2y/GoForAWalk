import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.SignIn.rawValue,
    targets: [
        .interface(
            module: .feature(.SignIn),
            dependencies: []
        ),
        .implements(
            module: .feature(.SignIn),
            dependencies: [
                .domain(target: .Auth, type: .interface),
                .domain(target: .Auth)
            ]
        ),
        .tests(module: .feature(.SignIn), dependencies: [
            .feature(target: .SignIn),
            .domain(target: .Auth, type: .testing)
        ])
    ]
)
