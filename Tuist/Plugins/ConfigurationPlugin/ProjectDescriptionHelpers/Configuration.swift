
import ProjectDescription

public extension Path {
    static func relativeToXCConfig(type: ConfigurationName, name: String) -> Path {
        return .relativeToRoot("XCConfig/\(name)/\(name)-\(type.rawValue).xcconfig")
    }
}
