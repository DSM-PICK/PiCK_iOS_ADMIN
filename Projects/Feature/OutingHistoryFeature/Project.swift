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
    name: "OutingHistoryFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).OutingHistoryFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "OutingHistoryFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).OutingHistoryFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "OutingHistoryFeatureInterface"),
        .Projects.outingHistoryDomainInterface,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let testTarget = Target.target(
    name: "OutingHistoryFeatureTests",
    destinations: env.destination,
    product: .unitTests,
    bundleId: "\(env.organizationName).OutingHistoryFeatureTests",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "OutingHistoryFeature"),
        .target(name: "OutingHistoryFeatureInterface"),
        .Projects.outingHistoryDomainInterface
    ]
)

let project = Project(
    name: "OutingHistoryFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget, testTarget]
)
