import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.UserService.rawValue,
    targets: [
        .interface(
            module: .domain(.UserService),
            dependencies: []
        ),
        .implements(
            module: .domain(.UserService),
            dependencies: [
                .domain(target: .UserService, type: .interface),
                .core(target: .Networking, type: .interface),
                .shared(target: .Util),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .domain(.UserService),
            dependencies: [
                .domain(target: .UserService, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.UserService),
            dependencies: [
                .domain(target: .UserService)
            ]
        )
    ]
)
