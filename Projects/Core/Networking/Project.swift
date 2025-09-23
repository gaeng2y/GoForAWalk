import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.Networking.rawValue,
    targets: [
        .interface(
            module: .core(.Networking),
            dependencies: []
        ),
        .implements(
            module: .core(.Networking),
            dependencies: [
                .core(target: .Networking, type: .interface),
                .core(target: .KeyChainStore),
                .shared(target: .Util)
            ]
        ),
        .testing(
            module: .core(.Networking),
            dependencies: [
                .core(target: .Networking, type: .interface)
            ]
        ),
        .tests(
            module: .core(.Networking),
            dependencies: [
                .core(target: .Networking)
            ]
        )
    ]
)
