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
    base: [:],
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

let needleScript: TargetScript = .pre(
    script: "/opt/homebrew/bin/needle generate Sources/Application/DI/NeedleGenerated.swift Sources ../Feature",
    name: "Run Needle",
    outputPaths: ["Projects/App/Sources/Application/DI/NeedleGenerated.swift"]
)

let appDependencies: [TargetDependency] = [
    .Features.baseFeature,
    .Features.signinFeature,
    .Features.signinFeatureInterface,
    .Features.signupFeature,
    .Features.signupFeatureInterface,
    .Features.onboardingFeature,
    .Features.onboardingFeatureInterface,
    .Projects.baseDomainInterface,
    .Projects.authDomainInterface,
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
    scripts: [needleScript],
    dependencies: appDependencies,
    settings: targetSettings
)

let schemes: [Scheme] = [
    .makeScheme(target: .dev, name: "\(env.targetName)"),
    .makeScheme(target: .stage, name: "\(env.targetName)"),
    .makeScheme(target: .prod, name: "\(env.targetName)")
]

let project = Project(
    name: env.appName,
    organizationName: env.organizationName,
    settings: projectSettings,
    targets: [appTarget],
    schemes: schemes
)
