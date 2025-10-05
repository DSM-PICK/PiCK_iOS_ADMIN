import ProjectDescription

public extension TargetDependency {
    struct Projects {}
    struct Features {}
    struct Shared {}
}

public extension TargetDependency.Projects {
    static let core = TargetDependency.project(
        target: "Core",
        path: .relativeToRoot("Projects/Core")
    )
    static let domain = TargetDependency.project(
        target: "Domain",
        path: .relativeToRoot("Projects/Domain")
    )
    static let authDomain = TargetDependency.project(
        target: "AuthDomain",
        path: .relativeToRoot("Projects/Domain/AuthDomain")
    )
}

public extension TargetDependency.Features {
    static let baseFeature = TargetDependency.project(
        target: "BaseFeature",
        path: .relativeToRoot("Projects/Feature/BaseFeature")
    )
    static let authFeature = TargetDependency.project(
        target: "AuthFeature",
        path: .relativeToRoot("Projects/Feature/AuthFeature")
    )
    // Add other features here
}

public extension TargetDependency.Shared {
    static let designSystem = TargetDependency.project(
        target: "DesignSystem",
        path: .relativeToRoot("Projects/Shared/DesignSystem")
    )
    static let thirdPartyLib = TargetDependency.project(
        target: "ThirdPartyLib",
        path: .relativeToRoot("Projects/Shared/ThirdPartyLib")
    )
    static let utility = TargetDependency.project(
        target: "Utility",
        path: .relativeToRoot("Projects/Shared/Utility")
    )
}