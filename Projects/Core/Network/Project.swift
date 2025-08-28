import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.Network.rawValue,
    targets: [
        .interface(
            module: .core(.Network),
            dependencies: []
        ),
        .implements(
            module: .core(.Network),
            dependencies: [
                .core(target: .Network, type: .interface),
                .core(target: .KeyChainStore),
                .shared(target: .Util)
            ]
        ),
        .testing(
            module: .core(.Network),
            dependencies: [
                .core(target: .Network, type: .interface)
            ]
        ),
        .tests(
            module: .core(.Network),
            dependencies: [
                .core(target: .Network)
            ]
        )
    ]
)
