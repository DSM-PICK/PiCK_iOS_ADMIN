import ProjectDescription

public struct ProjectEnvironment {
    public let appName: String
    public let targetName: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let destination: Destinations
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    appName: "PiCK_iOS_ADMIN",
    targetName: "PiCK_iOS_ADMIN",
    organizationName: "com.team.pick",
    deploymentTargets: .iOS("15.0"),
    destination: .iOS,
    baseSetting: ["OTHER_LDFLAGS": ["$(inherited) -Objc"]]
)
