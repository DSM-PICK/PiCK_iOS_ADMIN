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
    name: "WithDrawDomainInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "$(env.organizationName).WithDrawDomainInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib
    ]
)

let implementationTarget = Target.target(
    name: "WithDrawDomain",
    destinations: env.destination,
    product: .framework,
    bundleId: "$(env.organizationName).WithDrawDomain",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "WithDrawDomainInterface"),
        .Projects.baseDomain,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "WithDrawDomain",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
