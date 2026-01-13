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
    name: "SchoolMealDomainInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "com.team.pick.SchoolMealDomainInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib
    ]
)

let implementationTarget = Target.target(
    name: "SchoolMealDomain",
    destinations: env.destination,
    product: .framework,
    bundleId: "com.team.pick.SchoolMealDomain",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "SchoolMealDomainInterface"),
        .Projects.baseDomain,
        .Shared.thirdPartyLib,
        .Shared.utility
    ]
)

let project = Project(
    name: "SchoolMealDomain",
    organizationName: "com.team.pick",
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
