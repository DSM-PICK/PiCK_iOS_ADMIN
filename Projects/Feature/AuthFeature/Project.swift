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
    name: "AuthFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).AuthFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/AuthFeatureInterface.swift"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "AuthFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).AuthFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "AuthFeatureInterface"),
        .Projects.authDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let project = Project(
    name: "AuthFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
