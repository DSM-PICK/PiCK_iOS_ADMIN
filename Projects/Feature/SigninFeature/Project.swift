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
    name: "SigninFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).SigninFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/SigninFeatureInterface.swift"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "SigninFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "\(env.organizationName).SigninFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "SigninFeatureInterface"),
        .Projects.authDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let project = Project(
    name: "SigninFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
