import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.FeedFeature.rawValue,
    targets: [
        .interface(module: .feature(.FeedFeature)),
        .implements(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature, type: .interface),
                .domain(target: .FeedService)
            ]
        ),
        .testing(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature, type: .interface),
                .domain(target: .FeedService, type: .interface),
                .domain(target: .FeedService),
                .userInterface(target: .DesignSystem)
            ]
        ),
        .tests(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature)
            ]
        ),
        .demo(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature)
            ]
        )
    ]
)
