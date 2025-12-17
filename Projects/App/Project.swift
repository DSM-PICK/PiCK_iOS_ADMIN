import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin


let projectSettings: Settings = .settings(
    base: env.baseSetting,
    configurations: [
        .debug(
            name: ConfigurationName.configuration("DEV"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.dev, name: "\(env.targetName)")
        ),
        .debug(
            name: ConfigurationName.configuration("STAGE"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.stage, name: "\(env.targetName)")
        ),
        .release(
            name: ConfigurationName.configuration("PROD"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.prod, name: "\(env.targetName)")
        )
    ]
)

let targetSettings: Settings = .settings(
    base: ["OTHER_LDFLAGS": "-ObjC"],
    configurations: [
        .debug(
            name: ConfigurationName.configuration("DEV"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.dev, name: "\(env.targetName)")
        ),
        .debug(
            name: ConfigurationName.configuration("STAGE"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.stage, name: "\(env.targetName)")
        ),
        .release(
            name: ConfigurationName.configuration("PROD"),
            xcconfig: .relativeToXCConfig(type: ProjectDeployTarget.prod, name: "\(env.targetName)")
        )
    ]
)

let firebaseCheckScript: TargetScript = .pre(
    script: """
    FIREBASE_PATH="${SRCROOT}/../../Projects/App/Resources/Firebase"
    if [ ! -d "$FIREBASE_PATH" ]; then
      echo "error: ❌ Firebase folder not found at Projects/App/Resources/Firebase"
      echo "error: ⚠️  This is a required security file. Please add the Firebase folder before generating."
      exit 1
    fi
    """,
    name: "Check Firebase Folder",
    basedOnDependencyAnalysis: false
)

let needleScript: TargetScript = .pre(
    script: """
    if which needle >/dev/null; then
      cd "${SRCROOT}/../.."
      needle generate Projects/App/Sources/Application/DI/NeedleGenerated.swift Projects
    else
      echo "warning: Needle not installed, run: brew install needle"
    fi
    """,
    name: "Run Needle",
    basedOnDependencyAnalysis: false
)

let appDependencies: [TargetDependency] = [
    .external(name: "FirebaseMessaging"),
    .Features.baseFeature,
    .Features.signinFeature,
    .Features.signinFeatureInterface,
    .Features.signupFeature,
    .Features.signupFeatureInterface,
    .Features.onboardingFeature,
    .Features.onboardingFeatureInterface,
    .Features.homeFeature,
    .Features.homeFeatureInterface,
    .Features.allTabFeature,
    .Features.allTabFeatureInterface,
    .Features.planFeature,
    .Features.planFeatureInterface,
    .Features.schoolMealFeature,
    .Features.schoolMealFeatureInterface,
    .Features.acceptFeature,
    .Features.acceptFeatureInterface,
    .Features.resignFeature,
    .Features.resignFeatureInterface,
    .Features.selfStudyCheckFeature,
    .Features.selfStudyCheckFeatureInterface,
    .Features.outingHistoryFeature,
    .Features.outingHistoryFeatureInterface,
    .Features.classroomMoveListFeature,
    .Features.classroomMoveListFeatureInterface,
    .Features.bugReportFeature,
    .Features.bugReportFeatureInterface,
    .Features.changePasswordFeature,
    .Features.changePasswordFeatureInterface,
    .Features.outListFeature,
    .Features.outListFeatureInterface,
    .Features.checkSelfStudyTeacherFeature,
    .Features.checkSelfStudyTeacherFeatureInterface,
    .Projects.baseDomainInterface,
    .Projects.authDomain,
    .Projects.authDomainInterface,
    .Projects.homeDomain,
    .Projects.homeDomainInterface,
    .Projects.allTabDomain,
    .Projects.allTabDomainInterface,
    .Projects.planDomain,
    .Projects.planDomainInterface,
    .Projects.schoolMealDomain,
    .Projects.schoolMealDomainInterface,
    .Projects.acceptDomain,
    .Projects.acceptDomainInterface,
    .Projects.outListDomain,
    .Projects.outListDomainInterface,
    .Projects.checkSelfStudyTeacherDomain,
    .Projects.checkSelfStudyTeacherDomainInterface,
    .Projects.selfStudyCheckDomain,
    .Projects.selfStudyCheckDomainInterface,
    .Projects.outingHistoryDomain,
    .Projects.outingHistoryDomainInterface,
    .Projects.classroomMoveListDomain,
    .Projects.classroomMoveListDomainInterface,
    .Projects.bugReportDomain,
    .Projects.bugReportDomainInterface,
    .Projects.changePasswordDomain,
    .Projects.changePasswordDomainInterface,
    .Projects.teacherDomain,
    .Projects.teacherDomainInterface,
    .Projects.core,
    .Shared.thirdPartyLib,
    .Shared.utility
]

let appTarget: Target = .target(
    name: env.appName,
    destinations: env.destination,
    product: .app,
    bundleId: "\(env.organizationName).PiCK-iOS-ADMIN",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .file(path: "Support/Info.plist"),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    entitlements: .file(path: "Support/\(env.targetName).entitlements"),
    scripts: [firebaseCheckScript, needleScript],
    dependencies: appDependencies,
    settings: targetSettings
)

let schemes: [Scheme] = [
    .scheme(
        name: "\(env.targetName)-DEV",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .dev),
        archiveAction: .archiveAction(configuration: .dev),
        profileAction: .profileAction(configuration: .dev),
        analyzeAction: .analyzeAction(configuration: .dev)
    ),
    .scheme(
        name: "\(env.targetName)-STAGE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .stage),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    ),
    .scheme(
        name: "\(env.targetName)-PROD",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .prod),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
    )
]

let project = Project(
    name: env.appName,
    organizationName: env.organizationName,
    settings: projectSettings,
    targets: [appTarget],
    schemes: schemes
)
