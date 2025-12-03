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
    name: "AuthDomainInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).AuthDomainInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib,
        .Projects.baseDomain
    ]
)

let implementationTarget = Target.target(
    name: "AuthDomain",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).AuthDomain",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "AuthDomainInterface")
    ]
)

let testTarget = Target.target(
    name: "AuthDomainTests",
    destinations: env.destination,
    product: .unitTests,
    bundleId: "\(env.organizationName).AuthDomainTests",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "AuthDomain"),
        .target(name: "AuthDomainInterface"),
        .Projects.baseDomain
    ]
)

let project = Project(
    name: "AuthDomain",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget, testTarget]
)
