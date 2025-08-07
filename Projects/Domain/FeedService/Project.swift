import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.FeedService.rawValue,
    targets: [
        .interface(
            module: .domain(.FeedService),
            dependencies: [
                .domain(target: .Auth),
                .core(target: .Network, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.FeedService),
            dependencies: [
                .domain(target: .FeedService, type: .interface),
                .core(target: .Network),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .domain(.FeedService),
            dependencies: [
                .domain(target: .FeedService, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.FeedService),
            dependencies: [
                .domain(target: .FeedService)
            ]
        )
    ]
)
