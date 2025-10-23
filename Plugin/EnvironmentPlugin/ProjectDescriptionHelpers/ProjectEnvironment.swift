import Foundation
import ProjectDescription

public struct ProjectEnvironment {
    public let name: String
    public let organizationName: String
    public let destinations: Destinations
    public let deploymentTargets: DeploymentTargets
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    name: "GoForAWalk",
    organizationName: "com.gaeng2y",
    destinations: [.iPhone],
    deploymentTargets: .iOS("18.0"),
    baseSetting: [
        "DEVELOPMENT_TEAM": "8UV3Y69NB7"
    ]
)
