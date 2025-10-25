
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
    name: "HomeDomainInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).HomeDomainInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib
    ]
)

let implementationTarget = Target.target(
    name: "HomeDomain",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).HomeDomain",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "HomeDomainInterface"),
        .Projects.baseDomain,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "HomeDomain",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
