import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.KeyChainStore.rawValue,
    targets: [
        .interface(
            module: .core(.KeyChainStore),
            dependencies: []
        ),
        .implements(
            module: .core(.KeyChainStore),
            dependencies: [
                .core(target: .KeyChainStore, type: .interface)
            ]
        ),
        .testing(
            module: .core(.KeyChainStore),
            dependencies: [
                .core(target: .KeyChainStore, type: .interface)
            ]
        ),
        .tests(
            module: .core(.KeyChainStore),
            dependencies: [
                .core(target: .KeyChainStore)
            ]
        )
    ]
)
