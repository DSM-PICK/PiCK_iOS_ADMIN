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
    name: "PlanFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "com.team.pick.PlanFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/PlanInterface.swift"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "PlanFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "com.team.pick.PlanFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "PlanFeatureInterface"),
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
        .SPM.PDS
    ]
)

let project = Project(
    name: "PlanFeature",
    organizationName: "com.team.pick",
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
