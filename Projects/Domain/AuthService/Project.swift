import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.AuthService.rawValue,
    targets: [
        .interface(
            module: .domain(.AuthService),
            dependencies: []
        ),
        .implements(
            module: .domain(.AuthService),
            dependencies: [
                .domain(target: .AuthService, type: .interface),
                .core(target: .Networking, type: .interface),
                .core(target: .KeyChainStore, type: .interface),
                .shared(target: .Util),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .domain(.AuthService),
            dependencies: [
                .domain(target: .AuthService, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.AuthService),
            dependencies: [
                .domain(target: .AuthService)
            ]
        )
    ]
)
