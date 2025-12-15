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
    name: "AcceptFeatureInterface",
    destinations: env.destination,
    product: .staticLibrary,
    bundleId: "\(env.organizationName).AcceptFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "AcceptFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).AcceptFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "AcceptFeatureInterface"),
        .Projects.acceptDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "AcceptFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
