import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MainFeature.rawValue,
    targets: [
        .interface(
            module: .feature(.MainFeature),
            dependencies: [
                .feature(target: .FeedFeature, type: .interface),
                .feature(target: .ProfileFeature, type: .interface),
                .feature(target: .HistoryFeature, type: .interface),
                .feature(target: .SettingsFeature, type: .interface),
                .feature(target: .RecordFeature, type: .interface),
                
                .domain(target: .FeedService, type: .interface),
                
                .userInterface(target: .DesignSystem),
                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .implements(
            module: .feature(.MainFeature),
            dependencies: [
                .feature(target: .MainFeature, type: .interface),
                .feature(target: .FeedFeature, type: .interface),
                .feature(target: .HistoryFeature, type: .interface),
                .feature(target: .RecordFeature, type: .interface),
                .feature(target: .ProfileFeature, type: .interface),

                .domain(target: .FeedService, type: .interface),

                .shared(target: .GlobalThirdPartyLibrary)
            ]
        ),
        .testing(
            module: .feature(.MainFeature),
            dependencies: [
                .feature(target: .MainFeature, type: .interface)
            ]
        ),
        .tests(
            module: .feature(.MainFeature),
            dependencies: [
                .feature(target: .MainFeature)
            ]
        )
    ]
)
