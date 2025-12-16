import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Shared.DependencyInjection.rawValue,
    targets: [
        .implements(
            module: .shared(.DependencyInjection),
            product: .framework,
            dependencies: [
                .shared(target: .GlobalThirdPartyLibrary),
                .userInterface(target: .DesignSystem),
                .core(target: .Networking, type: .interface),
                .core(target: .Networking, type: .sources),
                .core(target: .KeyChainStore, type: .interface),
                .core(target: .KeyChainStore, type: .sources),
                .core(target: .Camera, type: .interface),
                .core(target: .Camera, type: .sources),
            ]
        )
    ]
)
