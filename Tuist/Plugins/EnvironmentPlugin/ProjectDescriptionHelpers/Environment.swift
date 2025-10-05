
import ProjectDescription

public enum Environment {
    public static let appName = "PiCK_iOS_ADMIN"
    public static let targetName = "PiCK_iOS_ADMIN"
    public static let organizationName = "com.pick"
    public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
    public static let destination: Destinations = [.iPhone]
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
        .marketingVersion("1.0.0")
        .currentProjectVersion("1")
}

public let env = Environment.self
