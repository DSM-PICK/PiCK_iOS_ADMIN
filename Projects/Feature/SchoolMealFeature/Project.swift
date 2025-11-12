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
    name: "SchoolMealFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).SchoolMealFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "SchoolMealFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).SchoolMealFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "SchoolMealFeatureInterface"),
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "SchoolMealFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
