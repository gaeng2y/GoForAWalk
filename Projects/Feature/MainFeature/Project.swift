import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MainFeature.rawValue,
    targets: [
        .interface(module: .feature(.MainFeature)),
        .implements(
            module: .feature(.MainFeature),
            dependencies: [
                .feature(target: .MainFeature, type: .interface),
                .feature(target: .FeedFeature),
                .feature(target: .RecordFeature),
                .feature(target: .ProfileFeature),
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
