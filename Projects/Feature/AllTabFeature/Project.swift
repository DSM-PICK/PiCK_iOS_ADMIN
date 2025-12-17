import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let configurations: [Configuration] = [
    .debug(name: .dev),
    .debug(name: .stage),
    .release(name: .prod)
]

let settings: Settings = .settings(
    base: env.baseSetting.merging(.codeSign),
    configurations: configurations,
    defaultSettings: .recommended
)

let interfaceTarget = Target.target(
    name: "AllTabFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).AllTabFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/AllTabFeatureInterface.swift"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "AllTabFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).AllTabFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "AllTabFeatureInterface"),
        .Projects.allTabDomainInterface,
        .Features.homeFeature,
        .Features.checkSelfStudyTeacherFeature,
        .Features.bugReportFeature,
        .Features.selfStudyCheckFeature,
        .Shared.utility,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "AllTabFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
