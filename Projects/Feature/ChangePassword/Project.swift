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
    name: "ChangePasswordFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).ChangePasswordFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "ChangePasswordFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).ChangePasswordFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "ChangePasswordFeatureInterface"),
        .Projects.authDomainInterface,
        .Projects.changePasswordDomainInterface,
        .Shared.utility,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let testTarget = Target.target(
    name: "ChangePasswordFeatureTests",
    destinations: env.destination,
    product: .unitTests,
    bundleId: "\(env.organizationName).ChangePasswordFeatureTests",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "ChangePasswordFeature"),
        .target(name: "ChangePasswordFeatureInterface"),
        .Projects.authDomainInterface
    ]
)

let project = Project(
    name: "ChangePasswordFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget, testTarget]
)
