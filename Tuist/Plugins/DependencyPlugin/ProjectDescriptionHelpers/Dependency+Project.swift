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
    static let baseDomain = TargetDependency.project(
        target: "BaseDomain",
        path: .relativeToRoot("Projects/Domain/BaseDomain")
    )
    static let baseDomainInterface = TargetDependency.project(
        target: "BaseDomainInterface",
        path: .relativeToRoot("Projects/Domain/BaseDomain")
    )
    static let authDomain = TargetDependency.project(
        target: "AuthDomain",
        path: .relativeToRoot("Projects/Domain/AuthDomain")
    )
    static let authDomainInterface = TargetDependency.project(
        target: "AuthDomainInterface",
        path: .relativeToRoot("Projects/Domain/AuthDomain")
    )
    static let homeDomain = TargetDependency.project(
        target: "HomeDomain",
        path: .relativeToRoot("Projects/Domain/HomeDomain")
    )
    static let homeDomainInterface = TargetDependency.project(
        target: "HomeDomainInterface",
        path: .relativeToRoot("Projects/Domain/HomeDomain")
    )
    static let allTabDomain = TargetDependency.project(
        target: "AllTabDomain",
        path: .relativeToRoot("Projects/Domain/AllTabDomain")
    )
    static let allTabDomainInterface = TargetDependency.project(
        target: "AllTabDomainInterface",
        path: .relativeToRoot("Projects/Domain/AllTabDomain")
    )
    static let planDomain = TargetDependency.project(
        target: "PlanDomain",
        path: .relativeToRoot("Projects/Domain/PlanDomain")
    )
    static let planDomainInterface = TargetDependency.project(
        target: "PlanDomainInterface",
        path: .relativeToRoot("Projects/Domain/PlanDomain")
    )
    static let schoolMealDomain = TargetDependency.project(
        target: "SchoolMealDomain",
        path: .relativeToRoot("Projects/Domain/SchoolMealDomain")
    )
    static let schoolMealDomainInterface = TargetDependency.project(
        target: "SchoolMealDomainInterface",
        path: .relativeToRoot("Projects/Domain/SchoolMealDomain")
    )
    static let acceptDomain = TargetDependency.project(
        target: "AcceptDomain",
        path: .relativeToRoot("Projects/Domain/AcceptDomain")
    )
    static let acceptDomainInterface = TargetDependency.project(
        target: "AcceptDomainInterface",
        path: .relativeToRoot("Projects/Domain/AcceptDomain")
    )
    static let outListDomain = TargetDependency.project(
        target: "OutListDomain",
        path: .relativeToRoot("Projects/Domain/OutListDomain")
    )
    static let outListDomainInterface = TargetDependency.project(
        target: "OutListDomainInterface",
        path: .relativeToRoot("Projects/Domain/OutListDomain")
    )
    static let checkSelfStudyTeacherDomain = TargetDependency.project(
        target: "CheckSelfStudyTeacherDomain",
        path: .relativeToRoot("Projects/Domain/CheckSelfStudyTeacher")
    )
    static let checkSelfStudyTeacherDomainInterface = TargetDependency.project(
        target: "CheckSelfStudyTeacherDomainInterface",
        path: .relativeToRoot("Projects/Domain/CheckSelfStudyTeacher")
    )
    static let selfStudyCheckDomain = TargetDependency.project(
        target: "SelfStudyCheckDomain",
        path: .relativeToRoot("Projects/Domain/SelfStudyCheckDomain")
    )
    static let selfStudyCheckDomainInterface = TargetDependency.project(
        target: "SelfStudyCheckDomainInterface",
        path: .relativeToRoot("Projects/Domain/SelfStudyCheckDomain")
    static let outingHistoryDomain = TargetDependency.project(
        target: "OutingHistoryDomain",
        path: .relativeToRoot("Projects/Domain/OutingHistoryDomain")
    )
    static let outingHistoryDomainInterface = TargetDependency.project(
        target: "OutingHistoryDomainInterface",
        path: .relativeToRoot("Projects/Domain/OutingHistoryDomain")
    )
    static let classroomMoveListDomain = TargetDependency.project(
        target: "ClassroomMoveListDomain",
        path: .relativeToRoot("Projects/Domain/ClassroomMoveListDomain")
    )
    static let classroomMoveListDomainInterface = TargetDependency.project(
        target: "ClassroomMoveListDomainInterface",
        path: .relativeToRoot("Projects/Domain/ClassroomMoveListDomain")
    )
    static let bugReportDomain = TargetDependency.project(
        target: "BugReportDomain",
        path: .relativeToRoot("Projects/Domain/BugReportDomain")
    )
    static let bugReportDomainInterface = TargetDependency.project(
        target: "BugReportDomainInterface",
        path: .relativeToRoot("Projects/Domain/BugReportDomain")
    )
    static let changePasswordDomain = TargetDependency.project(
        target: "ChangePasswordDomain",
        path: .relativeToRoot("Projects/Domain/ChangePasswordDomain")
    )
    static let changePasswordDomainInterface = TargetDependency.project(
        target: "ChangePasswordDomainInterface",
        path: .relativeToRoot("Projects/Domain/ChangePasswordDomain")
    )
    static let teacherDomain = TargetDependency.project(
        target: "TeacherDomain",
        path: .relativeToRoot("Projects/Domain/TeacherDomain")
    )
    static let teacherDomainInterface = TargetDependency.project(
        target: "TeacherDomainInterface",
        path: .relativeToRoot("Projects/Domain/TeacherDomain")
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
    static let onboardingFeature = TargetDependency.project(
        target: "OnboardingFeature",
        path: .relativeToRoot("Projects/Feature/OnboardingFeature")
    )
    static let onboardingFeatureInterface = TargetDependency.project(
        target: "OnboardingFeatureInterface",
        path: .relativeToRoot("Projects/Feature/OnboardingFeature")
    )
    static let homeFeature = TargetDependency.project(
        target: "HomeFeature",
        path: .relativeToRoot("Projects/Feature/HomeFeature")
    )
    static let homeFeatureInterface = TargetDependency.project(
        target: "HomeFeatureInterface",
        path: .relativeToRoot("Projects/Feature/HomeFeature")
    )
    static let allTabFeature = TargetDependency.project(
        target: "AllTabFeature",
        path: .relativeToRoot("Projects/Feature/AllTabFeature")
    )
    static let allTabFeatureInterface = TargetDependency.project(
        target: "AllTabFeatureInterface",
        path: .relativeToRoot("Projects/Feature/AllTabFeature")
    )
    static let planFeature = TargetDependency.project(
        target: "PlanFeature",
        path: .relativeToRoot("Projects/Feature/PlanFeature")
    )
    static let planFeatureInterface = TargetDependency.project(
        target: "PlanFeatureInterface",
        path: .relativeToRoot("Projects/Feature/PlanFeature")
    )
    static let schoolMealFeature = TargetDependency.project(
        target: "SchoolMealFeature",
        path: .relativeToRoot("Projects/Feature/SchoolMealFeature")
    )
    static let schoolMealFeatureInterface = TargetDependency.project(
        target: "SchoolMealFeatureInterface",
        path: .relativeToRoot("Projects/Feature/SchoolMealFeature")
    )
    static let acceptFeature = TargetDependency.project(
        target: "AcceptFeature",
        path: .relativeToRoot("Projects/Feature/AcceptFeature")
    )
    static let acceptFeatureInterface = TargetDependency.project(
        target: "AcceptFeatureInterface",
        path: .relativeToRoot("Projects/Feature/AcceptFeature")
    )
    static let outListFeature = TargetDependency.project(
        target: "OutListFeature",
        path: .relativeToRoot("Projects/Feature/OutListFeature")
    )
    static let outListFeatureInterface = TargetDependency.project(
        target: "OutListFeatureInterface",
        path: .relativeToRoot("Projects/Feature/OutListFeature")
    )
    static let checkSelfStudyTeacherFeature = TargetDependency.project(
        target: "CheckSelfStudyTeacherFeature",
        path: .relativeToRoot("Projects/Feature/CheckSelfStudyTeacherFeature")
    )
    static let checkSelfStudyTeacherFeatureInterface = TargetDependency.project(
        target: "CheckSelfStudyTeacherFeatureInterface",
        path: .relativeToRoot("Projects/Feature/CheckSelfStudyTeacherFeature")
    )
    static let bugReportFeature = TargetDependency.project(
        target: "BugReportFeature",
        path: .relativeToRoot("Projects/Feature/BugReport")
    )
    static let bugReportFeatureInterface = TargetDependency.project(
        target: "BugReportFeatureInterface",
        path: .relativeToRoot("Projects/Feature/BugReport")
    )
    static let changePasswordFeature = TargetDependency.project(
        target: "ChangePasswordFeature",
        path: .relativeToRoot("Projects/Feature/ChangePassword")
    )
    static let changePasswordFeatureInterface = TargetDependency.project(
        target: "ChangePasswordFeatureInterface",
        path: .relativeToRoot("Projects/Feature/ChangePassword")
    )
    static let selfStudyCheckFeature = TargetDependency.project(
        target: "SelfStudyCheckFeature",
        path: .relativeToRoot("Projects/Feature/SelfStudyCheck")
    )
    static let selfStudyCheckFeatureInterface = TargetDependency.project(
        target: "SelfStudyCheckFeatureInterface",
        path: .relativeToRoot("Projects/Feature/SelfStudyCheck")
    static let classroomMoveListFeature = TargetDependency.project(
        target: "ClassroomMoveListFeature",
        path: .relativeToRoot("Projects/Feature/ClassroomMoveListFeature")
    )
    static let classroomMoveListFeatureInterface = TargetDependency.project(
        target: "ClassroomMoveListFeatureInterface",
        path: .relativeToRoot("Projects/Feature/ClassroomMoveListFeature")
    )
    static let outingHistoryFeature = TargetDependency.project(
        target: "OutingHistoryFeature",
        path: .relativeToRoot("Projects/Feature/OutingHistoryFeature")
    )
    static let outingHistoryFeatureInterface = TargetDependency.project(
        target: "OutingHistoryFeatureInterface",
        path: .relativeToRoot("Projects/Feature/OutingHistoryFeature")
    )
    // other Module
}

public extension TargetDependency.Shared {
    static let thirdPartyLib = TargetDependency.project(
        target: "ThirdPartyLib",
        path: .relativeToRoot("Projects/Shared/ThirdPartyLib")
    )
    static let utility = TargetDependency.project(
        target: "Utility",
        path: .relativeToRoot("Projects/Shared/Utility")
    )
}
