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
    name: "FirstFeatureFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: ".FirstFeatureFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/FirstFeatureInterface.swift"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "FirstFeatureFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: ".FirstFeatureFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "FirstFeatureFeatureInterface"),
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let project = Project(
    name: "FirstFeatureFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
