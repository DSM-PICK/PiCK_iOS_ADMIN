import ProjectDescription

public struct ProjectEnvironment {
    public let targetName: String
    public let targetTestName: String
    public let organizationName: String
    public let deploymentTarget: ProjectDescription.DeploymentTargets
    public let platform: ProjectDescription.Platform
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    targetName: "DSM-PiCK",
    targetTestName: "DSM-PiCKTests",
    organizationName: "com.team.pick",
    deploymentTarget: .iOS("15.0"),
    platform: ProjectDescription.Platform.iOS,
    baseSetting: ["OTHER_LDFLAGS": ["$(inherited) -Objc"]]
)
