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
                .domain(target: .AuthService, type: .interface),
                .domain(target: .AuthService)
            ]
        ),
        .tests(module: .feature(.SignIn), dependencies: [
            .feature(target: .SignIn),
            .domain(target: .AuthService, type: .testing)
        ])
    ]
)
