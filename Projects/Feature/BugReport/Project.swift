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
    name: "BugReportFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).BugReportFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "BugReportFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).BugReportFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "BugReportFeatureInterface"),
        .Projects.bugReportDomainInterface,
        .Shared.utility,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let testTarget = Target.target(
    name: "BugReportFeatureTests",
    destinations: env.destination,
    product: .unitTests,
    bundleId: "\(env.organizationName).BugReportFeatureTests",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "BugReportFeature"),
        .target(name: "BugReportFeatureInterface"),
        .Projects.bugReportDomainInterface,
        .Shared.utility
    ]
)

let project = Project(
    name: "BugReportFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget, testTarget]
)
