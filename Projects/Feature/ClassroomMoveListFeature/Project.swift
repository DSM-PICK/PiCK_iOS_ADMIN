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
    name: "ClassroomMoveListFeatureFeatureInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "$(env.organizationName).ClassroomMoveListFeatureFeatureInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)

let implementationTarget = Target.target(
    name: "ClassroomMoveListFeatureFeature",
    destinations: env.destination,
    product: .staticFramework,
    bundleId: "$(env.organizationName).ClassroomMoveListFeatureFeature",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "ClassroomMoveListFeatureFeatureInterface"),
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)

let project = Project(
    name: "ClassroomMoveListFeatureFeature",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
