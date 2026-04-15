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
    name: "SignupFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).SignupFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "SignupFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).SignupFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "SignupFeatureInterface"),
        .Projects.authDomainInterface,
        .SPM.ComposableArchitecture,
        .Shared.thirdPartyLib
    ]
)

let testTarget = Target.target(
    name: "SignupFeatureTests",
    destinations: env.destination,
    product: .unitTests,
    bundleId: "\(env.organizationName).SignupFeatureTests",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Tests/**"],
    dependencies: [
        .target(name: "SignupFeature"),
        .target(name: "SignupFeatureInterface"),
        .Projects.authDomainInterface
    ]
)

let project = Project(
    name: "SignupFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget, testTarget]
)
