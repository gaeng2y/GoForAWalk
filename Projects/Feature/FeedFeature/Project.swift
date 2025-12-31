import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.FeedFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.FeedFeature),
            dependencies: [
                .domain(target: .FeedService, type: .interface),
                .feature(target: .RecordFeature, type: .interface),
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature, type: .interface),
                .feature(target: .RecordFeature, type: .interface),
                .domain(target: .FeedService, type: .interface),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .feature(.FeedFeature),
            dependencies: [
                .feature(target: .FeedFeature, type: .interface),
                .domain(target: .FeedService, type: .interface),
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
