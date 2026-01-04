import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.HistoryFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.HistoryFeature),
            dependencies: [
                .domain(target: .FeedService, type: .interface),
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.HistoryFeature),
            dependencies: [
                .feature(target: .HistoryFeature, type: .interface),
                .domain(target: .FeedService, type: .interface)
            ]
        ),
        .testing(module: .feature(.HistoryFeature), dependencies: [
            .feature(target: .HistoryFeature, type: .interface)
        ]),
        .tests(module: .feature(.HistoryFeature), dependencies: [
            .feature(target: .HistoryFeature)
        ]),
        .demo(module: .feature(.HistoryFeature), dependencies: [
            .feature(target: .HistoryFeature)
        ])
    ]
)
