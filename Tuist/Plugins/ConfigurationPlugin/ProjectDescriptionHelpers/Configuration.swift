
import ProjectDescription

public extension ConfigurationName {
    static var dev: ConfigurationName { .configuration("DEV") }
    static var stage: ConfigurationName { .configuration("STAGE") }
    static var prod: ConfigurationName { .configuration("PROD") }
}

public extension Path {
    static func relativeToXCConfig(type: ConfigurationName, name: String) -> Path {
        return .relativeToRoot("XCConfig/\(name)/\(name)-\(type.rawValue).xcconfig")
    }
}
