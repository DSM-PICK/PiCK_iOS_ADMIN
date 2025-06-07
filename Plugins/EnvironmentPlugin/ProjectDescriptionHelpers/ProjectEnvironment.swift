import ProjectDescription

public struct ProjectEnvironment {
    public let appName: String
    public let targetName: String
    public let targetTestName: String
    public let organizationName: String
    public let deploymentTarget: DeploymentTarget
    public let platform: Platform
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    appName: "PiCK_iOS_ADMIN",
    targetName: "PiCK_iOS_ADMIN",
    targetTestName: "DSM-PiCKTests",
    organizationName: "com.team.pick",
    deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
    platform: .iOS,
    baseSetting: ["OTHER_LDFLAGS": ["$(inherited) -Objc"]]
)
