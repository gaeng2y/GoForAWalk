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
                .core(target: .Networking, type: .interface),
                .core(target: .Networking, type: .sources),
                .core(target: .KeyChainStore, type: .interface),
                .core(target: .KeyChainStore, type: .sources),
                .core(target: .Camera, type: .interface),
                .core(target: .Camera, type: .sources),
                
                .domain(target: .Auth, type: .interface),
                .domain(target: .Auth, type: .sources),
                .domain(target: .CameraService, type: .interface),
                .domain(target: .CameraService, type: .sources),
                .domain(target: .FeedService, type: .interface),
                .domain(target: .FeedService, type: .sources),
                .domain(target: .UserService, type: .interface),
                .domain(target: .UserService, type: .sources),
                
                .feature(target: .FeedFeature, type: .interface),
                .feature(target: .FeedFeature, type: .sources),
                .feature(target: .MainFeature, type: .interface),
                .feature(target: .MainFeature, type: .sources),
                .feature(target: .ProfileFeature, type: .interface),
                .feature(target: .ProfileFeature, type: .sources),
                .feature(target: .RecordFeature, type: .interface),
                .feature(target: .RecordFeature, type: .sources),
                .feature(target: .SettingsFeature, type: .interface),
                .feature(target: .SettingsFeature, type: .sources),
                .feature(target: .SignIn, type: .interface),
                .feature(target: .SignIn, type: .sources)
            ]
        )
    ]
)
