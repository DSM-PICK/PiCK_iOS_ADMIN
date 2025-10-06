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
    static let authDomainInterface = TargetDependency.project(
        target: "AuthDomainInterface",
        path: .relativeToRoot("Projects/Domain/AuthDomain")
    )
}

public extension TargetDependency.Features {
    static let baseFeature = TargetDependency.project(
        target: "BaseFeature",
        path: .relativeToRoot("Projects/Feature/BaseFeature")
    )
    static let signinFeature = TargetDependency.project(
        target: "SigninFeature",
        path: .relativeToRoot("Projects/Feature/SigninFeature")
    )
    static let signinFeatureInterface = TargetDependency.project(
        target: "SigninFeatureInterface",
        path: .relativeToRoot("Projects/Feature/SigninFeature")
    )
    static let signupFeature = TargetDependency.project(
        target: "SignupFeature",
        path: .relativeToRoot("Projects/Feature/SignupFeature")
    )
    static let signupFeatureInterface = TargetDependency.project(
        target: "SignupFeatureInterface",
        path: .relativeToRoot("Projects/Feature/SignupFeature")
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