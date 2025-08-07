import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Shared.GlobalThirdPartyLibrary.rawValue,
    targets: [
        .implements(
            module: .shared(.GlobalThirdPartyLibrary),
            product: .framework,
            dependencies: [
                .SPM.tca,
                .SPM.kakaoCommon,
                .SPM.kakaoAuth,
                .SPM.kakaoUser
            ]
        )
    ]
)
