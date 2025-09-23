import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.Auth.rawValue,
    targets: [
        .interface(
            module: .domain(.Auth),
            dependencies: [
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .domain(.Auth),
            dependencies: [
                .domain(target: .Auth, type: .interface),
                .core(target: .Networking),
                .core(target: .KeyChainStore),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .domain(.Auth),
            dependencies: [
                .domain(target: .Auth, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.Auth),
            dependencies: [
                .domain(target: .Auth)
            ]
        )
    ]
)
